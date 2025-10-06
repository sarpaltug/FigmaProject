//
//  UserSessionManager.swift
//  FigmaProject
//
//  Created by Sarp Ugrasiz on 27.08.2025.
//

import SwiftUI
import Foundation
import FirebaseFirestore

class UserSessionManager: ObservableObject {
    static let shared = UserSessionManager()
    
    // MARK: - Published Properties
    @Published var isLoggedIn: Bool = false
    @Published var currentUserProfile: UserProfileModel?
    @Published var rememberMe: Bool = false
    
    // MARK: - AppStorage Properties (Persistent)
    @AppStorage("user_uid") private var storedUserUID: String = ""
    @AppStorage("user_email") private var storedUserEmail: String = ""
    @AppStorage("user_display_name") private var storedUserDisplayName: String = ""
    @AppStorage("user_selected_language") private var storedSelectedLanguage: String = ""
    @AppStorage("user_total_xp") private var storedTotalXP: Int = 0
    @AppStorage("remember_me") private var storedRememberMe: Bool = false
    @AppStorage("last_login_date") private var lastLoginDate: String = ""
    @AppStorage("login_method") private var loginMethod: String = "" // "email", "apple", "google"
    
    // MARK: - UserDefaults Keys
    private let userDefaultsKeys = [
        "user_uid",
        "user_email", 
        "user_display_name",
        "user_selected_language",
        "user_total_xp",
        "remember_me",
        "last_login_date",
        "login_method"
    ]
    
    private init() {
        loadUserSession()
    }
    
    // MARK: - Session Management
    
    func saveUserSession(userProfile: UserProfileModel, method: LoginMethod, rememberUser: Bool = true) {
        DispatchQueue.main.async {
            // Update published properties
            self.isLoggedIn = true
            self.currentUserProfile = userProfile
            self.rememberMe = rememberUser
            
            // Save to AppStorage (persistent)
            if rememberUser {
                self.storedUserUID = userProfile.uid
                self.storedUserEmail = userProfile.email
                self.storedUserDisplayName = userProfile.displayName
                self.storedSelectedLanguage = userProfile.selectedLanguage
                self.storedTotalXP = userProfile.totalXP
                self.storedRememberMe = true
                self.lastLoginDate = ISO8601DateFormatter().string(from: Date())
                self.loginMethod = method.rawValue
            }
            
            // Also save to UserDefaults for backward compatibility
            UserDefaults.standard.set(userProfile.displayName, forKey: "userName")
            UserDefaults.standard.set(userProfile.selectedLanguage, forKey: "selectedLanguage")
        }
    }
    
    func loadUserSession() {
        DispatchQueue.main.async {
            // Check if user should be remembered
            if self.storedRememberMe && !self.storedUserUID.isEmpty {
                // Create user profile from stored data
                let userData: [String: Any] = [
                    "uid": self.storedUserUID,
                    "email": self.storedUserEmail,
                    "displayName": self.storedUserDisplayName,
                    "selectedLanguage": self.storedSelectedLanguage,
                    "totalXP": self.storedTotalXP,
                    "createdAt": Timestamp(date: Date()) // Placeholder
                ]
                
                self.currentUserProfile = UserProfileModel(data: userData)
                self.isLoggedIn = true
                self.rememberMe = true
                
                // Set backward compatibility
                UserDefaults.standard.set(self.storedUserDisplayName, forKey: "userName")
                UserDefaults.standard.set(self.storedSelectedLanguage, forKey: "selectedLanguage")
            } else {
                self.clearSession()
            }
        }
    }
    
    func updateUserProfile(_ profile: UserProfileModel) {
        DispatchQueue.main.async {
            self.currentUserProfile = profile
            
            // Update stored data if remember me is enabled
            if self.rememberMe {
                self.storedUserUID = profile.uid
                self.storedUserEmail = profile.email
                self.storedUserDisplayName = profile.displayName
                self.storedSelectedLanguage = profile.selectedLanguage
                self.storedTotalXP = profile.totalXP
            }
            
            // Update backward compatibility
            UserDefaults.standard.set(profile.displayName, forKey: "userName")
            UserDefaults.standard.set(profile.selectedLanguage, forKey: "selectedLanguage")
        }
    }
    
    func clearSession() {
        DispatchQueue.main.async {
            // Clear published properties
            self.isLoggedIn = false
            self.currentUserProfile = nil
            self.rememberMe = false
            
            // Clear AppStorage
            self.storedUserUID = ""
            self.storedUserEmail = ""
            self.storedUserDisplayName = ""
            self.storedSelectedLanguage = ""
            self.storedTotalXP = 0
            self.storedRememberMe = false
            self.lastLoginDate = ""
            self.loginMethod = ""
            
            // Clear backward compatibility UserDefaults
            UserDefaults.standard.removeObject(forKey: "userName")
            UserDefaults.standard.removeObject(forKey: "selectedLanguage")
        }
    }
    
    // MARK: - Helper Methods
    
    func getLastLoginDate() -> Date? {
        guard !lastLoginDate.isEmpty else { return nil }
        return ISO8601DateFormatter().date(from: lastLoginDate)
    }
    
    func getLoginMethod() -> LoginMethod? {
        return LoginMethod(rawValue: loginMethod)
    }
    
    func isSessionExpired(maxDays: Int = 30) -> Bool {
        guard let lastLogin = getLastLoginDate() else { return true }
        let daysSinceLogin = Calendar.current.dateComponents([.day], from: lastLogin, to: Date()).day ?? 0
        return daysSinceLogin > maxDays
    }
    
    // MARK: - Debug Methods
    
    func printSessionInfo() {
        print("=== User Session Info ===")
        print("Is Logged In: \(isLoggedIn)")
        print("Remember Me: \(rememberMe)")
        print("User UID: \(storedUserUID)")
        print("User Email: \(storedUserEmail)")
        print("Display Name: \(storedUserDisplayName)")
        print("Selected Language: \(storedSelectedLanguage)")
        print("Total XP: \(storedTotalXP)")
        print("Last Login: \(lastLoginDate)")
        print("Login Method: \(loginMethod)")
        print("========================")
    }
}

// MARK: - Login Method Enum

enum LoginMethod: String, CaseIterable {
    case email = "email"
    case apple = "apple" 
    case google = "google"
    
    var displayName: String {
        switch self {
        case .email: return "Email"
        case .apple: return "Apple"
        case .google: return "Google"
        }
    }
    
    var icon: String {
        switch self {
        case .email: return "envelope.fill"
        case .apple: return "applelogo"
        case .google: return "globe"
        }
    }
}

