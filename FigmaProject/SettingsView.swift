//
//  SettingsView.swift
//  FigmaProject
//
//  Created by Sarp Ugrasiz on 27.08.2025.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var firebaseManager: FirebaseManager
    @EnvironmentObject var themeManager: ThemeManager
    @State private var userName: String = "User"
    @State private var showBugReport = false
    @State private var showAbout = false
    @State private var showTerms = false
    @State private var navigateToSignUp = false
    @State private var isLoggingOut = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background
                Color(hex: "#121417")
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header
                    HStack {
                        // Back button (invisible, for spacing)
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 20, weight: .medium))
                                .foregroundColor(.white)
                        }
                        
                        Spacer()
                        
                        // Title
                        Text("Settings")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        // Settings icon
                        Image(systemName: "gearshape")
                            .font(.system(size: 20))
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    .padding(.bottom, 30)
                    
                    // Menu Items
                    VStack(spacing: 0) {
                        // Dark Mode Toggle
                        HStack {
                            Image(systemName: themeManager.isDarkMode ? "moon.fill" : "sun.max.fill")
                                .font(.system(size: 20))
                                .foregroundColor(.white)
                                .frame(width: 24, height: 24)
                            
                            Text("Dark Mode")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            // Toggle Switch
                            Menu {
                                ForEach(AppTheme.allCases, id: \.self) { theme in
                                    Button(action: {
                                        themeManager.currentTheme = theme
                                    }) {
                                        HStack {
                                            Text(theme.displayName)
                                            if themeManager.currentTheme == theme {
                                                Image(systemName: "checkmark")
                                            }
                                        }
                                    }
                                }
                            } label: {
                                HStack(spacing: 4) {
                                    Text(themeManager.currentTheme.displayName)
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(Color(hex: "#9EADB8"))
                                    Image(systemName: "chevron.down")
                                        .font(.system(size: 12))
                                        .foregroundColor(Color(hex: "#9EADB8"))
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 16)
                        .background(Color(hex: "#1E2328"))
                        .cornerRadius(12)
                        
                        // Divider
                        Rectangle()
                            .fill(Color(hex: "#2A2D32"))
                            .frame(height: 1)
                        
                        // Settings
                        SettingsMenuItem(
                            icon: "gearshape.fill",
                            title: "Settings",
                            isHighlighted: true
                        ) {
                            // Settings action
                        }
                        
                        // Help
                        SettingsMenuItem(
                            icon: "questionmark.circle",
                            title: "Help"
                        ) {
                            // Help action
                        }
                        
                        // Report a bug
                        SettingsMenuItem(
                            icon: "ant",
                            title: "Report a bug"
                        ) {
                            showBugReport = true
                        }
                        
                        // About
                        SettingsMenuItem(
                            icon: "info.circle",
                            title: "About"
                        ) {
                            showAbout = true
                        }
                        
                        // Terms
                        SettingsMenuItem(
                            icon: "doc.text",
                            title: "Terms"
                        ) {
                            showTerms = true
                        }
                        
                        // Log out
                        SettingsMenuItem(
                            icon: "arrow.right.square",
                            title: isLoggingOut ? "Logging out..." : "Log out"
                        ) {
                            logOut()
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    Spacer()
                    
                    // Bottom user info
                    VStack(spacing: 8) {
                        // Profile image placeholder
                        Circle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 40, height: 40)
                            .overlay(
                                Image(systemName: "person.fill")
                                    .font(.system(size: 18))
                                    .foregroundColor(.gray)
                            )
                        
                        // User name from sign-up
                        Text(userName)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.white)
                    }
                    .padding(.bottom, 30)
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            // Firebase'den kullanıcı adını al
            userName = firebaseManager.currentUser?.displayName ?? "User"
        }
        .navigationDestination(isPresented: $showBugReport) {
            BugReportView()
        }
        .navigationDestination(isPresented: $showAbout) {
            AboutView()
        }
        .navigationDestination(isPresented: $showTerms) {
            TermsOfServiceView()
        }
        .navigationDestination(isPresented: $navigateToSignUp) {
            ContentView().navigationBarHidden(true)
        }
    }
    
    // MARK: - Firebase Methods
    
    private func logOut() {
        isLoggingOut = true
        
        do {
            try firebaseManager.signOut()
            // Firebase sign out başarılı olduğunda otomatik olarak OnboardingView'a yönlendirilecek
        } catch {
            print("Error signing out: \(error)")
        }
        
        isLoggingOut = false
    }
}

struct SettingsMenuItem: View {
    let icon: String
    let title: String
    var isHighlighted: Bool = false
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                // Icon
                Image(systemName: icon)
                    .font(.system(size: 18))
                    .foregroundColor(.white)
                    .frame(width: 24, height: 24)
                
                // Title
                Text(title)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(
                isHighlighted ? Color(hex: "#2A2E35") : Color.clear
            )
            .cornerRadius(12)
        }
        .padding(.horizontal, isHighlighted ? 0 : 20)
        .padding(.vertical, 2)
    }
}



#Preview {
    SettingsView()
}
