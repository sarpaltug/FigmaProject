//
//  ProfileView.swift
//  FigmaProject
//
//  Created by Sarp Ugrasiz on 27.08.2025.
//

import SwiftUI

struct ProfileAchievement {
    let id = UUID()
    let title: String
    let level: String
    let icon: String
    let isCompleted: Bool
}

struct ProfileView: View {
    @EnvironmentObject var firebaseManager: FirebaseManager
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var databaseManager: DatabaseManager
    @State var userName: String = "User"
    @State var userEmail: String = ""
    @State var totalXP: Int = 0
    @State var currentLevel: Int = 1
    @State var currentStreak: Int = 0
    @State var userRank: String = "Beginner"
    
    let achievements = [
        ProfileAchievement(title: "Champion", level: "Level 5", icon: "trophy.fill", isCompleted: false),
        ProfileAchievement(title: "Photogenic", level: "Level 2", icon: "camera.fill", isCompleted: false),
        ProfileAchievement(title: "Sage", level: "Level 3", icon: "book.fill", isCompleted: false)
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background
                AppColors.background(for: themeManager.isDarkMode)
                    .ignoresSafeArea()
            
                ScrollView {
                    VStack(spacing: 0) {
                        // Header
                        HStack {
                            Text("Profile")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(AppColors.primaryText(for: themeManager.isDarkMode))
                            
                            Spacer()
                            
                            // Settings button
                            NavigationLink(destination: SettingsView()
                                .environmentObject(firebaseManager)
                                .environmentObject(themeManager)) {
                                Image(systemName: "gearshape")
                                    .font(.system(size: 20))
                                    .foregroundColor(AppColors.primaryText(for: themeManager.isDarkMode))
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
                                .foregroundColor(AppColors.primaryText(for: themeManager.isDarkMode))
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
                                    .foregroundColor(AppColors.primaryText(for: themeManager.isDarkMode))
                                
                                Text("@\(userName.lowercased().replacingOccurrences(of: " ", with: "_"))")
                                    .font(.system(size: 16, weight: .regular))
                                    .foregroundColor(AppColors.secondaryText(for: themeManager.isDarkMode))
                                
                                Text("Joined Jan 2020")
                                    .font(.system(size: 14, weight: .regular))
                                    .foregroundColor(AppColors.secondaryText(for: themeManager.isDarkMode))
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
                        
                        // Stats section
                        HStack(spacing: 12) {
                            StatCard(title: "Day streak", value: "\(currentStreak)")
                            StatCard(title: "Total XP", value: "\(totalXP)")
                            StatCard(title: "Level", value: "\(currentLevel)")
                            StatCard(title: "Rank", value: userRank)
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, 30)
                        
                        // Achievements section
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Text("Achievements")
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(AppColors.primaryText(for: themeManager.isDarkMode))
                                Spacer()
                                Button("See all") {
                                    // Handle see all
                                }
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(Color(hex: "#2699E8"))
                            }
                            .padding(.horizontal, 16)
                            
                            // Achievement list
                            VStack(spacing: 12) {
                                ForEach(achievements, id: \.id) { achievement in
                                    AchievementRow(achievement: achievement)
                                }
                            }
                            .padding(.horizontal, 16)
                        }
                        .padding(.bottom, 100) // Space for tab bar
                    }
                }
            }
            .onAppear {
                loadUserData()
            }
            .onChange(of: databaseManager.currentUserProfile) { profile in
                if let profile = profile {
                    totalXP = profile.totalXP
                    currentLevel = profile.currentLevel
                    currentStreak = profile.currentStreak
                    userRank = profile.getUserRank()
                    userName = profile.displayName
                    userEmail = profile.email
                }
            }
        }
    }
    
    // MARK: - Firebase Methods
    
    func loadUserData() {
        if let user = firebaseManager.currentUser {
            userName = user.displayName ?? "User"
            userEmail = user.email ?? ""
            
            // DatabaseManager'dan kullanıcı profilini yükle
            Task {
                do {
                    if let profile = try await databaseManager.getUserProfile(uid: user.uid) {
                        await MainActor.run {
                            totalXP = profile.totalXP
                            currentLevel = profile.currentLevel
                            currentStreak = profile.currentStreak
                            userRank = profile.getUserRank()
                            userName = profile.displayName
                            userEmail = profile.email
                        }
                    }
                } catch {
                    print("Error loading user profile: \(error)")
                }
            }
        }
        
        // Real-time updates için DatabaseManager'ı dinle
        if let profile = databaseManager.currentUserProfile {
            totalXP = profile.totalXP
            currentLevel = profile.currentLevel
            currentStreak = profile.currentStreak
            userRank = profile.getUserRank()
            userName = profile.displayName
            userEmail = profile.email
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
    let achievement: ProfileAchievement
    
    var body: some View {
        HStack(spacing: 16) {
            // Achievement icon
            Image(systemName: achievement.icon)
                .font(.system(size: 24))
                .foregroundColor(achievement.isCompleted ? Color(hex: "#2699E8") : Color(hex: "#9EADB8"))
                .frame(width: 40, height: 40)
                .background(
                    Circle()
                        .fill(achievement.isCompleted ? Color(hex: "#2699E8").opacity(0.2) : Color(hex: "#2A2E35"))
                )
            
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

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .environmentObject(FirebaseManager.shared)
            .environmentObject(ThemeManager.shared)
    }
}
