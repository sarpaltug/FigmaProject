//
//  FigmaProjectApp.swift
//  FigmaProject
//
//  Created by Sarp Ugrasiz on 5.08.2025.
//

import SwiftUI
import Firebase

@main
struct FigmaProjectApp: App {
    @StateObject private var firebaseManager = FirebaseManager.shared
    @StateObject private var themeManager = ThemeManager.shared
    @StateObject private var sessionManager = UserSessionManager.shared
    @StateObject private var databaseManager = DatabaseManager.shared
    let persistenceController = PersistenceController.shared

    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            if firebaseManager.isAuthenticated {
                // Kullanıcı giriş yapmış
                MainTabView()
                    .environmentObject(firebaseManager)
                    .environmentObject(themeManager)
                    .environmentObject(sessionManager)
                    .environmentObject(databaseManager)
                    .preferredColorScheme(themeManager.currentTheme == .light ? .light : 
                                        themeManager.currentTheme == .dark ? .dark : nil)
            } else {
                // Kullanıcı giriş yapmamış
                if #available(iOS 16.0, *) {
                    NavigationStack {
                        OnboardingView()
                            .environmentObject(firebaseManager)
                            .environmentObject(themeManager)
                            .environmentObject(sessionManager)
                            .environmentObject(databaseManager)
                            .navigationBarHidden(true)
                    }
                    .preferredColorScheme(themeManager.currentTheme == .light ? .light : 
                                        themeManager.currentTheme == .dark ? .dark : nil)
                } else {
                    NavigationView {
                        OnboardingView()
                            .environmentObject(firebaseManager)
                            .environmentObject(themeManager)
                            .environmentObject(sessionManager)
                            .environmentObject(databaseManager)
                            .navigationBarHidden(true)
                    }
                    .preferredColorScheme(themeManager.currentTheme == .light ? .light : 
                                        themeManager.currentTheme == .dark ? .dark : nil)
                }
            }
        }
    }
}
