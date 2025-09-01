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

class FirebaseManager: ObservableObject {
    static let shared = FirebaseManager()
    
    @Published var isAuthenticated = false
    @Published var currentUser: User?
    
    private let auth = Auth.auth()
    private let firestore = Firestore.firestore()
    
    init() {
        // Firebase konfigürasyonunu kontrol et
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
        
        // Auth state listener
        auth.addStateDidChangeListener { [weak self] _, user in
            DispatchQueue.main.async {
                self?.currentUser = user
                self?.isAuthenticated = user != nil
            }
        }
    }
    
    // MARK: - Authentication Methods
    
    func signUp(email: String, password: String, name: String) async throws {
        let result = try await auth.createUser(withEmail: email, password: password)
        
        // Kullanıcı profilini güncelle
        let changeRequest = result.user.createProfileChangeRequest()
        changeRequest.displayName = name
        try await changeRequest.commitChanges()
        
        // Firestore'da kullanıcı bilgilerini kaydet
        try await saveUserToFirestore(user: result.user, name: name)
    }
    
    func signIn(email: String, password: String) async throws {
        try await auth.signIn(withEmail: email, password: password)
    }
    
    func signOut() throws {
        try auth.signOut()
        // UserDefaults'ları temizle
        UserDefaults.standard.removeObject(forKey: "userName")
        UserDefaults.standard.removeObject(forKey: "selectedLanguage")
    }
    
    // MARK: - Firestore Methods
    
    private func saveUserToFirestore(user: User, name: String) async throws {
        let userData: [String: Any] = [
            "uid": user.uid,
            "email": user.email ?? "",
            "displayName": name,
            "createdAt": Timestamp(date: Date()),
            "selectedLanguage": "",
            "totalXP": 0,
            "completedLessons": []
        ]
        
        try await firestore.collection("users").document(user.uid).setData(userData)
    }
    
    func updateUserLanguage(_ language: String) async throws {
        guard let user = currentUser else { return }
        
        try await firestore.collection("users").document(user.uid).updateData([
            "selectedLanguage": language,
            "updatedAt": Timestamp(date: Date())
        ])
    }
    
    func getUserData() async throws -> [String: Any]? {
        guard let user = currentUser else { return nil }
        
        let document = try await firestore.collection("users").document(user.uid).getDocument()
        return document.data()
    }
    
    func updateUserXP(_ xp: Int) async throws {
        guard let user = currentUser else { return }
        
        try await firestore.collection("users").document(user.uid).updateData([
            "totalXP": FieldValue.increment(Int64(xp)),
            "updatedAt": Timestamp(date: Date())
        ])
    }
    
    func getLeaderboard() async throws -> [[String: Any]] {
        let snapshot = try await firestore.collection("users")
            .order(by: "totalXP", descending: true)
            .limit(to: 50)
            .getDocuments()
        
        return snapshot.documents.map { $0.data() }
    }
}

// MARK: - User Model
struct UserProfile {
    let uid: String
    let email: String
    let displayName: String
    let selectedLanguage: String
    let totalXP: Int
    let createdAt: Date
    
    init(data: [String: Any]) {
        self.uid = data["uid"] as? String ?? ""
        self.email = data["email"] as? String ?? ""
        self.displayName = data["displayName"] as? String ?? ""
        self.selectedLanguage = data["selectedLanguage"] as? String ?? ""
        self.totalXP = data["totalXP"] as? Int ?? 0
        self.createdAt = (data["createdAt"] as? Timestamp)?.dateValue() ?? Date()
    }
}
