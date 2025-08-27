//
//  ProfileView.swift
//  FigmaProject
//
//  Created by Sarp Ugrasiz on 27.08.2025.
//

import SwiftUI

struct Achievement {
    let id = UUID()
    let title: String
    let level: String
    let icon: String
    let isCompleted: Bool
}

struct ProfileView: View {
    @State private var userName: String = UserDefaults.standard.string(forKey: "userName") ?? "User"
    
    let achievements = [
        Achievement(title: "Champion", level: "Level 5", icon: "trophy.fill", isCompleted: false),
        Achievement(title: "Photogenic", level: "Level 2", icon: "camera.fill", isCompleted: false),
        Achievement(title: "Sage", level: "Level 3", icon: "book.fill", isCompleted: false)
    ]
    
    var body: some View {
        ZStack {
            // Background
            Color(hex: "#121417")
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 0) {
                    // Header
                    HStack {
                        Text("Profile")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        // Settings button
                        Button(action: {
                            // Handle settings
                        }) {
                            Image(systemName: "gearshape")
                                .font(.system(size: 20))
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 20)
                    .padding(.bottom, 30)
                    
                    // Profile section
                    VStack(spacing: 16) {
                        // Avatar
                        Image(systemName: "person.circle.fill")
                            .font(.system(size: 80))
                            .foregroundColor(.white)
                            .frame(width: 100, height: 100)
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.orange.opacity(0.8), Color.brown.opacity(0.6)]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .clipShape(Circle())
                        
                        // Name and username
                        VStack(spacing: 4) {
                            Text(userName)
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.white)
                            
                            Text("@\(userName.lowercased().replacingOccurrences(of: " ", with: "_"))")
                                .font(.system(size: 16, weight: .regular))
                                .foregroundColor(Color(hex: "#9EADB8"))
                            
                            Text("Joined Jan 2020")
                                .font(.system(size: 14, weight: .regular))
                                .foregroundColor(Color(hex: "#9EADB8"))
                                .padding(.top, 4)
                        }
                        
                        // Add Friends button
                        Button(action: {
                            // Handle add friends
                        }) {
                            Text("Add Friends")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 48)
                                .background(Color(hex: "#2699E8"))
                                .cornerRadius(24)
                        }
                        .padding(.horizontal, 40)
                        .padding(.top, 8)
                    }
                    .padding(.bottom, 40)
                    
                    // Statistics section
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text("Statistics")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.white)
                            Spacer()
                        }
                        .padding(.horizontal, 16)
                        
                        // Stats grid
                        VStack(spacing: 12) {
                            HStack(spacing: 12) {
                                StatCard(title: "Day streak", value: "12")
                                StatCard(title: "Total credits", value: "356")
                            }
                            
                            HStack(spacing: 12) {
                                StatCard(title: "Current league", value: "Silver")
                                StatCard(title: "Top 3 finishes", value: "15")
                            }
                        }
                        .padding(.horizontal, 16)
                    }
                    .padding(.bottom, 40)
                    
                    // Achievements section
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text("Achievements")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.white)
                            Spacer()
                        }
                        .padding(.horizontal, 16)
                        
                        VStack(spacing: 12) {
                            ForEach(achievements, id: \.id) { achievement in
                                AchievementRow(achievement: achievement)
                            }
                        }
                        .padding(.horizontal, 16)
                    }
                    .padding(.bottom, 40)
                    
                    // User info at bottom
                    VStack(spacing: 8) {
                        Text(userName)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                        
                        HStack(spacing: 4) {
                            Circle()
                                .fill(Color.green)
                                .frame(width: 8, height: 8)
                            Text("Offile")
                                .font(.system(size: 14, weight: .regular))
                                .foregroundColor(Color(hex: "#9EADB8"))
                        }
                    }
                    .padding(.bottom, 100) // Space for tab bar
                }
            }
        }
        .onAppear {
            // Refresh user name from UserDefaults when view appears
            userName = UserDefaults.standard.string(forKey: "userName") ?? "User"
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 14, weight: .regular))
                .foregroundColor(Color(hex: "#9EADB8"))
            
            Text(value)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(Color(hex: "#293338"))
        .cornerRadius(12)
    }
}

struct AchievementRow: View {
    let achievement: Achievement
    
    var body: some View {
        HStack(spacing: 16) {
            // Achievement icon
            Image(systemName: achievement.icon)
                .font(.system(size: 20))
                .foregroundColor(.white)
                .frame(width: 40, height: 40)
                .background(Color(hex: "#293338"))
                .cornerRadius(8)
            
            // Achievement info
            VStack(alignment: .leading, spacing: 4) {
                Text(achievement.title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                
                Text(achievement.level)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(Color(hex: "#9EADB8"))
            }
            
            Spacer()
            
            // Claim button
            Button(action: {
                // Handle claim
            }) {
                Text("Claim")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color(hex: "#2699E8"))
                    .cornerRadius(16)
            }
            .disabled(achievement.isCompleted)
            .opacity(achievement.isCompleted ? 0.5 : 1.0)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    ProfileView()
}
