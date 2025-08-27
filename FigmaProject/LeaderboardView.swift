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
    let leaderboardUsers = [
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
                    // Stitch - Design with AI button (top left)
                    Button(action: {
                        // Handle stitch action
                    }) {
                        HStack(spacing: 8) {
                            Image(systemName: "wand.and.stars")
                                .font(.system(size: 14))
                                .foregroundColor(.white)
                            Text("Stitch - Design with AI")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.white)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.black.opacity(0.3))
                        .cornerRadius(16)
                    }
                    
                    Spacer()
                    
                    // Leaderboard title
                    Text("Leaderboard")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    // Balance space for centering
                    Rectangle()
                        .fill(Color.clear)
                        .frame(width: 140, height: 32)
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
                            ForEach(leaderboardUsers, id: \.id) { user in
                                LeaderboardRow(user: user)
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, 100) // Space for tab bar
                    }
                }
            }
        }
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
