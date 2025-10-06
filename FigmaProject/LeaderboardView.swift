//
//  LeaderboardView.swift
//  FigmaProject
//
//  Created by Sarp Ugrasiz on 27.08.2025.
//

import SwiftUI

struct LeaderboardUser {
    let id = UUID()
    let name: String
    let xp: Int
    let rank: Int
    let avatarImage: String
}

struct LeaderboardView: View {
    @EnvironmentObject var firebaseManager: FirebaseManager
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var sessionManager: UserSessionManager
    @EnvironmentObject var databaseManager: DatabaseManager
    @State private var leaderboardUsers: [UserProfileModel] = []
    @State private var isLoading = true
    
    let staticLeaderboardUsers = [
        LeaderboardUser(name: "You", xp: 1200, rank: 1, avatarImage: "person.circle.fill"),
        LeaderboardUser(name: "Liam", xp: 1100, rank: 2, avatarImage: "person.circle.fill"),
        LeaderboardUser(name: "Olivia", xp: 1000, rank: 3, avatarImage: "person.circle.fill"),
        LeaderboardUser(name: "Noah", xp: 900, rank: 4, avatarImage: "person.circle.fill"),
        LeaderboardUser(name: "Ava", xp: 800, rank: 5, avatarImage: "person.circle.fill"),
        LeaderboardUser(name: "Ethan", xp: 700, rank: 6, avatarImage: "person.circle.fill"),
        LeaderboardUser(name: "Sophia", xp: 600, rank: 7, avatarImage: "person.circle.fill"),
        LeaderboardUser(name: "Jackson", xp: 500, rank: 8, avatarImage: "person.circle.fill"),
        LeaderboardUser(name: "Isabella", xp: 400, rank: 9, avatarImage: "person.circle.fill"),
        LeaderboardUser(name: "Aiden", xp: 300, rank: 10, avatarImage: "person.circle.fill")
    ]
    
    var body: some View {
        ZStack {
            // Background
            Color(hex: "#121417")
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Spacer()
                    
                    // Leaderboard title
                    Text("Leaderboard")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                    
                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.top, 20)
                .padding(.bottom, 20)
                
                // This Week section
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text("This Week")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .padding(.horizontal, 16)
                    
                    // Leaderboard list
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            if isLoading {
                                ForEach(staticLeaderboardUsers, id: \.id) { user in
                                    LeaderboardRow(user: user)
                                }
                            } else {
                                ForEach(Array(leaderboardUsers.enumerated()), id: \.element.id) { index, profile in
                                    RealLeaderboardRow(profile: profile, rank: index + 1)
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, 100) // Space for tab bar
                    }
                }
            }
            .onAppear {
                loadLeaderboard()
            }
        }
    }
    
    func loadLeaderboard() {
        Task {
            do {
                let profiles = try await databaseManager.getLeaderboard(limit: 50)
                await MainActor.run {
                    self.leaderboardUsers = profiles
                    self.isLoading = false
                }
            } catch {
                print("Error loading leaderboard: \(error)")
                // Keep showing static data
            }
        }
    }
}

struct RealLeaderboardRow: View {
    let profile: UserProfileModel
    let rank: Int
    
    var body: some View {
        HStack(spacing: 16) {
            // Rank
            Text("#\(rank)")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.white)
                .frame(width: 40, alignment: .leading)
            
            // Avatar
            Image(systemName: "person.circle.fill")
                .font(.system(size: 40))
                .foregroundColor(.blue)
            
            // User info
            VStack(alignment: .leading, spacing: 4) {
                Text(profile.displayName)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                
                Text("Level \(profile.currentLevel)")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            // XP
            Text("\(profile.totalXP) XP")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.orange)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color(hex: "#1E1E1E"))
        .cornerRadius(12)
    }
}

struct LeaderboardRow: View {
    let user: LeaderboardUser
    
    var body: some View {
        HStack(spacing: 16) {
            // Avatar
            Image(systemName: user.avatarImage)
                .font(.system(size: 32))
                .foregroundColor(.white)
                .frame(width: 60, height: 60)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.orange.opacity(0.8), Color.brown.opacity(0.6)]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .clipShape(Circle())
            
            // Name and XP
            VStack(alignment: .leading, spacing: 4) {
                Text(user.name)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                
                Text("\(user.xp) XP")
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(Color(hex: "#9EADB8"))
            }
            
            Spacer()
            
            // Rank
            Text("#\(user.rank)")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.white)
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    LeaderboardView()
}
