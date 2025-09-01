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
            } else {
                // Kullanıcı giriş yapmamış
                if #available(iOS 16.0, *) {
                    NavigationStack {
                        OnboardingView()
                            .environmentObject(firebaseManager)
                            .navigationBarHidden(true)
                    }
                } else {
                    NavigationView {
                        OnboardingView()
                            .environmentObject(firebaseManager)
                            .navigationBarHidden(true)
                    }
                }
            }
        }
    }
}
