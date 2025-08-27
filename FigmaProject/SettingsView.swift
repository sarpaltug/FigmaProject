//
//  SettingsView.swift
//  FigmaProject
//
//  Created by Sarp Ugrasiz on 27.08.2025.
//

import SwiftUI

struct SettingsView: View {
    @State private var userName: String = UserDefaults.standard.string(forKey: "userName") ?? "User"
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
                        Text("Stitch - Design with AI")
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
                            // Report bug action
                        }
                        
                        // About
                        SettingsMenuItem(
                            icon: "info.circle",
                            title: "About"
                        ) {
                            // About action
                        }
                        
                        // Terms
                        SettingsMenuItem(
                            icon: "doc.text",
                            title: "Terms"
                        ) {
                            // Terms action
                        }
                        
                        // Log out
                        SettingsMenuItem(
                            icon: "arrow.right.square",
                            title: "Log out"
                        ) {
                            // Log out action
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
            // Refresh user name from UserDefaults when view appears
            userName = UserDefaults.standard.string(forKey: "userName") ?? "User"
        }
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
