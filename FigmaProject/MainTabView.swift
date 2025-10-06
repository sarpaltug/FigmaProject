//
//  MainTabView.swift
//  FigmaProject
//
//  Created by Sarp Ugrasiz on 27.08.2025.
//

import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var firebaseManager: FirebaseManager
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var sessionManager: UserSessionManager
    @EnvironmentObject var databaseManager: DatabaseManager
    @State private var selectedTab: Int = 1 // Start with Lessons tab (index 1)
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Home Tab (Language Selection)
            LanguageSelectionView()
                .environmentObject(firebaseManager)
                .environmentObject(themeManager)
                .environmentObject(sessionManager)
                .environmentObject(databaseManager)
                .tabItem {
                    Image(systemName: selectedTab == 0 ? "house.fill" : "house")
                    Text("Home")
                }
                .tag(0)
            
            // Lessons Tab
            LessonsView()
                .environmentObject(firebaseManager)
                .environmentObject(themeManager)
                .environmentObject(sessionManager)
                .environmentObject(databaseManager)
                .tabItem {
                    Image(systemName: selectedTab == 1 ? "book.fill" : "book")
                    Text("Lessons")
                }
                .tag(1)
            
            // Leaderboard Tab
            LeaderboardView()
                .environmentObject(firebaseManager)
                .environmentObject(themeManager)
                .environmentObject(sessionManager)
                .environmentObject(databaseManager)
                .tabItem {
                    Image(systemName: selectedTab == 2 ? "trophy.fill" : "trophy")
                    Text("Leaderboard")
                }
                .tag(2)
            
            // Profile Tab
            ProfileView()
                .environmentObject(firebaseManager)
                .environmentObject(themeManager)
                .environmentObject(sessionManager)
                .environmentObject(databaseManager)
                .tabItem {
                    Image(systemName: selectedTab == 3 ? "person.fill" : "person")
                    Text("Profile")
                }
                .tag(3)
        }
        .accentColor(Color(hex: "#2699E8"))
        .onAppear {
            // Customize tab bar appearance
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor(red: 0.07, green: 0.08, blue: 0.09, alpha: 1.0) // #121417
            
            // Unselected item appearance
            appearance.stackedLayoutAppearance.normal.iconColor = UIColor(red: 0.62, green: 0.68, blue: 0.72, alpha: 1.0) // #9EADB8
            appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
                .foregroundColor: UIColor(red: 0.62, green: 0.68, blue: 0.72, alpha: 1.0)
            ]
            
            // Selected item appearance
            appearance.stackedLayoutAppearance.selected.iconColor = UIColor(red: 0.15, green: 0.6, blue: 0.91, alpha: 1.0) // #2699E8
            appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
                .foregroundColor: UIColor(red: 0.15, green: 0.6, blue: 0.91, alpha: 1.0)
            ]
            
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("SwitchToHomeTab"))) { _ in
            selectedTab = 0 // Switch to Home tab (LanguageSelectionView)
        }
    }
}

#Preview {
    MainTabView()
        .environmentObject(FirebaseManager.shared)
        .environmentObject(ThemeManager.shared)
}
