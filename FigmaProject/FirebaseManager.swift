//
//  FirebaseManager.swift
//  FigmaProject
//
//  Created by Sarp Ugrasiz on 27.08.2025.
//

import Firebase
import FirebaseAuth
import FirebaseFirestore
import SwiftUI
import AuthenticationServices
import CryptoKit

class FirebaseManager: ObservableObject {
    static let shared = FirebaseManager()
    
    @Published var isAuthenticated = false
    @Published var currentUser: User?
    
    private let auth = Auth.auth()
    private let firestore = Firestore.firestore()
    private var authStateListener: AuthStateDidChangeListenerHandle?
    private let sessionManager = UserSessionManager.shared
    private let databaseManager = DatabaseManager.shared
    
    // Apple Sign In için nonce
    private var currentNonce: String?
    
    init() {
        // Firebase konfigürasyonunu kontrol et
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
        
        // Auth state listener
        authStateListener = auth.addStateDidChangeListener { [weak self] _, user in
            DispatchQueue.main.async {
                self?.currentUser = user
                self?.isAuthenticated = user != nil
                
                // Session management
                if let user = user {
                    // User is authenticated, load/update session
                    Task {
                        await self?.loadUserProfileAndUpdateSession(user: user)
                    }
                } else {
                    // User is not authenticated, clear session
                    self?.sessionManager.clearSession()
                }
            }
        }
    }
    
    deinit {
        if let listener = authStateListener {
            auth.removeStateDidChangeListener(listener)
        }
    }
    
    // MARK: - Authentication Methods
    
    func signUp(email: String, password: String, name: String, rememberMe: Bool = true) async throws {
        let result = try await auth.createUser(withEmail: email, password: password)
        
        // Kullanıcı profilini güncelle
        let changeRequest = result.user.createProfileChangeRequest()
        changeRequest.displayName = name
        try await changeRequest.commitChanges()
        
        // Firestore'da kullanıcı bilgilerini kaydet
        try await saveUserToFirestore(user: result.user, name: name)
        
        // Session'ı kaydet
        let userProfile = UserProfile(data: [
            "uid": result.user.uid,
            "email": email,
            "displayName": name,
            "selectedLanguage": "",
            "totalXP": 0,
            "createdAt": Date()
        ])
        sessionManager.saveUserSession(userProfile: userProfile, method: .email, rememberUser: rememberMe)
    }
    
    func signIn(email: String, password: String, rememberMe: Bool = true) async throws {
        try await auth.signIn(withEmail: email, password: password)
        // Session management Auth State Listener'da yapılacak
    }
    
    func signOut() throws {
        try auth.signOut()
        // Session'ı temizle
        sessionManager.clearSession()
    }
    
    // MARK: - Apple Sign In Methods
    
    func signInWithApple(authorization: ASAuthorization) async throws {
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else {
            throw NSError(domain: "AppleSignInError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid Apple ID credential"])
        }
        
        guard let nonce = currentNonce else {
            throw NSError(domain: "AppleSignInError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid state: A login callback was received, but no login request was sent."])
        }
        
        guard let appleIDToken = appleIDCredential.identityToken else {
            throw NSError(domain: "AppleSignInError", code: 2, userInfo: [NSLocalizedDescriptionKey: "Unable to fetch identity token"])
        }
        
        guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
            throw NSError(domain: "AppleSignInError", code: 3, userInfo: [NSLocalizedDescriptionKey: "Unable to serialize token string from data"])
        }
        
        // Firebase credential oluştur
        let credential = OAuthProvider.appleCredential(withIDToken: idTokenString,
                                                       rawNonce: nonce,
                                                       fullName: appleIDCredential.fullName)
        
        // Firebase'e giriş yap
        let result = try await auth.signIn(with: credential)
        
        // Eğer bu ilk giriş ise, kullanıcı bilgilerini Firestore'a kaydet
        let isNewUser = result.additionalUserInfo?.isNewUser ?? false
        if isNewUser {
            let displayName = "\(appleIDCredential.fullName?.givenName ?? "") \(appleIDCredential.fullName?.familyName ?? "")".trimmingCharacters(in: .whitespaces)
            try await saveUserToFirestore(user: result.user, name: displayName.isEmpty ? "Apple User" : displayName)
        }
        
        // Session management Auth State Listener'da yapılacak
    }
    
    func prepareAppleSignIn() -> String {
        let nonce = randomNonceString()
        currentNonce = nonce
        return sha256(nonce)
    }
    
    // MARK: - Apple Sign In Helper Methods
    
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: [Character] = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }
    
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
    
    // MARK: - Session Management
    
    private func loadUserProfileAndUpdateSession(user: User) async {
        do {
            // DatabaseManager'dan kullanıcı profilini al
            let userProfileModel = try await databaseManager.getUserProfile(uid: user.uid)
            
            // Login metodunu belirle
            let loginMethod: LoginMethod
            if user.providerData.contains(where: { $0.providerID == "apple.com" }) {
                loginMethod = .apple
            } else if user.providerData.contains(where: { $0.providerID == "google.com" }) {
                loginMethod = .google
            } else {
                loginMethod = .email
            }
            
            // Legacy UserProfile oluştur (backward compatibility için)
            let legacyProfile: UserProfile
            if let profileModel = userProfileModel {
                legacyProfile = UserProfile(data: profileModel.toDictionary())
            } else {
                // Profil bulunamazsa minimal profil oluştur
                legacyProfile = UserProfile(data: [
                    "uid": user.uid,
                    "email": user.email ?? "",
                    "displayName": user.displayName ?? "User",
                    "selectedLanguage": "",
                    "totalXP": 0,
                    "createdAt": Date()
                ])
            }
            
            // Session'ı güncelle
            await MainActor.run {
                sessionManager.saveUserSession(userProfile: legacyProfile, method: loginMethod, rememberUser: true)
            }
            
            // Real-time listener başlat
            databaseManager.startListeningToUserProfile(uid: user.uid)
            
        } catch {
            print("Error loading user profile: \(error)")
            // Minimal profile oluştur
            let minimalProfile = UserProfile(data: [
                "uid": user.uid,
                "email": user.email ?? "",
                "displayName": user.displayName ?? "User",
                "selectedLanguage": "",
                "totalXP": 0,
                "createdAt": Date()
            ])
            
            await MainActor.run {
                sessionManager.saveUserSession(userProfile: minimalProfile, method: .email, rememberUser: true)
            }
        }
    }
    
    private func getUserDataForUser(user: User) async throws -> [String: Any]? {
        let document = try await firestore.collection("users").document(user.uid).getDocument()
        return document.data()
    }
    
    // MARK: - Firestore Methods
    
    private func saveUserToFirestore(user: User, name: String) async throws {
        // Create enhanced user profile
        let profileData: [String: Any] = [
            "uid": user.uid,
            "email": user.email ?? "",
            "displayName": name,
            "profileImageURL": user.photoURL?.absoluteString as Any,
            "selectedLanguage": "",
            "totalXP": 0,
            "currentLevel": 1,
            "completedLessons": [],
            "currentStreak": 0,
            "longestStreak": 0,
            "preferredTheme": "system",
            "notificationsEnabled": true,
            "soundEnabled": true,
            "dailyGoalXP": 50,
            "totalStudyTime": 0,
            "averageSessionTime": 0,
            "lessonsPerWeek": 0.0,
            "accuracyRate": 0.0,
            "createdAt": Timestamp(date: Date()),
            "updatedAt": Timestamp(date: Date()),
            "lastLoginAt": Timestamp(date: Date()),
            "isPublicProfile": true,
            "friendsCount": 0,
            "followersCount": 0,
            "followingCount": 0,
            "isPremium": false,
            "unlockedAchievements": [],
            "totalAchievements": 0
        ]
        
        let userProfile = UserProfileModel(data: profileData)
        try await databaseManager.createUserProfile(userProfile)
    }
    
    func updateUserLanguage(_ language: String) async throws {
        guard let user = currentUser else { return }
        try await databaseManager.updateUserLanguage(uid: user.uid, language: language)
    }
    
    func getUserData() async throws -> [String: Any]? {
        guard let user = currentUser else { return nil }
        let profile = try await databaseManager.getUserProfile(uid: user.uid)
        return profile?.toDictionary()
    }
    
    func updateUserXP(_ xp: Int) async throws {
        guard let user = currentUser else { return }
        try await databaseManager.updateUserXP(uid: user.uid, xpToAdd: xp)
    }
    
    func getLeaderboard() async throws -> [UserProfileModel] {
        return try await databaseManager.getLeaderboard(limit: 50)
    }
}

