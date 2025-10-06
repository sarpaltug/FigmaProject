//
//  UserProfileModel.swift
//  FigmaProject
//
//  Created by Sarp Ugrasiz on 27.08.2025.
//

import Foundation
import FirebaseFirestore

// MARK: - Enhanced User Profile Model

struct UserProfileModel: Codable, Identifiable, Equatable {
    let id: String // Same as uid
    let uid: String
    let email: String
    let displayName: String
    let profileImageURL: String?
    
    // Learning Progress
    let selectedLanguage: String
    let totalXP: Int
    let currentLevel: Int
    let completedLessons: [String]
    let currentStreak: Int
    let longestStreak: Int
    
    // User Preferences  
    let preferredTheme: String // "light", "dark", "system"
    let notificationsEnabled: Bool
    let soundEnabled: Bool
    let dailyGoalXP: Int
    
    // Statistics
    let totalStudyTime: Int // in minutes
    let averageSessionTime: Int // in minutes
    let lessonsPerWeek: Double
    let accuracyRate: Double // percentage
    
    // Timestamps
    let createdAt: Date
    let updatedAt: Date
    let lastLoginAt: Date
    let lastStudyAt: Date?
    
    // Social Features
    let isPublicProfile: Bool
    let friendsCount: Int
    let followersCount: Int
    let followingCount: Int
    
    // Premium Features
    let isPremium: Bool
    let premiumExpiresAt: Date?
    let subscriptionType: String? // "monthly", "yearly"
    
    // Achievements
    let unlockedAchievements: [String]
    let totalAchievements: Int
    
    init(data: [String: Any]) {
        self.id = data["uid"] as? String ?? ""
        self.uid = data["uid"] as? String ?? ""
        self.email = data["email"] as? String ?? ""
        self.displayName = data["displayName"] as? String ?? "User"
        self.profileImageURL = data["profileImageURL"] as? String
        
        // Learning Progress
        self.selectedLanguage = data["selectedLanguage"] as? String ?? ""
        self.totalXP = data["totalXP"] as? Int ?? 0
        self.currentLevel = data["currentLevel"] as? Int ?? 1
        self.completedLessons = data["completedLessons"] as? [String] ?? []
        self.currentStreak = data["currentStreak"] as? Int ?? 0
        self.longestStreak = data["longestStreak"] as? Int ?? 0
        
        // User Preferences
        self.preferredTheme = data["preferredTheme"] as? String ?? "system"
        self.notificationsEnabled = data["notificationsEnabled"] as? Bool ?? true
        self.soundEnabled = data["soundEnabled"] as? Bool ?? true
        self.dailyGoalXP = data["dailyGoalXP"] as? Int ?? 50
        
        // Statistics
        self.totalStudyTime = data["totalStudyTime"] as? Int ?? 0
        self.averageSessionTime = data["averageSessionTime"] as? Int ?? 0
        self.lessonsPerWeek = data["lessonsPerWeek"] as? Double ?? 0.0
        self.accuracyRate = data["accuracyRate"] as? Double ?? 0.0
        
        // Timestamps
        self.createdAt = (data["createdAt"] as? Timestamp)?.dateValue() ?? Date()
        self.updatedAt = (data["updatedAt"] as? Timestamp)?.dateValue() ?? Date()
        self.lastLoginAt = (data["lastLoginAt"] as? Timestamp)?.dateValue() ?? Date()
        self.lastStudyAt = (data["lastStudyAt"] as? Timestamp)?.dateValue()
        
        // Social Features
        self.isPublicProfile = data["isPublicProfile"] as? Bool ?? true
        self.friendsCount = data["friendsCount"] as? Int ?? 0
        self.followersCount = data["followersCount"] as? Int ?? 0
        self.followingCount = data["followingCount"] as? Int ?? 0
        
        // Premium Features
        self.isPremium = data["isPremium"] as? Bool ?? false
        self.premiumExpiresAt = (data["premiumExpiresAt"] as? Timestamp)?.dateValue()
        self.subscriptionType = data["subscriptionType"] as? String
        
        // Achievements
        self.unlockedAchievements = data["unlockedAchievements"] as? [String] ?? []
        self.totalAchievements = data["totalAchievements"] as? Int ?? 0
    }
    
    // Convert to dictionary for Firestore
    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [
            "uid": uid,
            "email": email,
            "displayName": displayName,
            "selectedLanguage": selectedLanguage,
            "totalXP": totalXP,
            "currentLevel": currentLevel,
            "completedLessons": completedLessons,
            "currentStreak": currentStreak,
            "longestStreak": longestStreak,
            "preferredTheme": preferredTheme,
            "notificationsEnabled": notificationsEnabled,
            "soundEnabled": soundEnabled,
            "dailyGoalXP": dailyGoalXP,
            "totalStudyTime": totalStudyTime,
            "averageSessionTime": averageSessionTime,
            "lessonsPerWeek": lessonsPerWeek,
            "accuracyRate": accuracyRate,
            "createdAt": Timestamp(date: createdAt),
            "updatedAt": Timestamp(date: updatedAt),
            "lastLoginAt": Timestamp(date: lastLoginAt),
            "isPublicProfile": isPublicProfile,
            "friendsCount": friendsCount,
            "followersCount": followersCount,
            "followingCount": followingCount,
            "isPremium": isPremium,
            "unlockedAchievements": unlockedAchievements,
            "totalAchievements": totalAchievements
        ]
        
        if let profileImageURL = profileImageURL {
            dict["profileImageURL"] = profileImageURL
        }
        
        if let lastStudyAt = lastStudyAt {
            dict["lastStudyAt"] = Timestamp(date: lastStudyAt)
        }
        
        if let premiumExpiresAt = premiumExpiresAt {
            dict["premiumExpiresAt"] = Timestamp(date: premiumExpiresAt)
        }
        
        if let subscriptionType = subscriptionType {
            dict["subscriptionType"] = subscriptionType
        }
        
        return dict
    }
}

// MARK: - Helper Extensions

extension UserProfileModel {
    // Calculate current level from XP
    static func calculateLevel(from xp: Int) -> Int {
        // Level formula: Level = floor(sqrt(XP / 100)) + 1
        return Int(floor(sqrt(Double(xp) / 100.0))) + 1
    }
    
    // Calculate XP needed for next level
    func xpNeededForNextLevel() -> Int {
        let nextLevel = currentLevel + 1
        let xpForNextLevel = (nextLevel - 1) * (nextLevel - 1) * 100
        return max(0, xpForNextLevel - totalXP)
    }
    
    // Calculate progress to next level (0.0 to 1.0)
    func progressToNextLevel() -> Double {
        let currentLevelXP = (currentLevel - 1) * (currentLevel - 1) * 100
        let nextLevelXP = currentLevel * currentLevel * 100
        let progressXP = totalXP - currentLevelXP
        let totalNeededXP = nextLevelXP - currentLevelXP
        
        return totalNeededXP > 0 ? Double(progressXP) / Double(totalNeededXP) : 0.0
    }
    
    // Check if user reached daily goal
    func reachedDailyGoal(todayXP: Int) -> Bool {
        return todayXP >= dailyGoalXP
    }
    
    // Get user rank based on total XP
    func getUserRank() -> String {
        switch totalXP {
        case 0..<100: return "Beginner"
        case 100..<500: return "Learner"
        case 500..<1000: return "Student"
        case 1000..<2500: return "Scholar"
        case 2500..<5000: return "Expert"
        case 5000..<10000: return "Master"
        default: return "Grandmaster"
        }
    }
    
    // Get streak emoji
    func getStreakEmoji() -> String {
        switch currentStreak {
        case 0: return "😴"
        case 1...3: return "🔥"
        case 4...7: return "🚀"
        case 8...15: return "⭐"
        case 16...30: return "💎"
        default: return "👑"
        }
    }
}

// MARK: - User Statistics Model

struct UserStatistics: Codable {
    let uid: String
    let dailyXP: [String: Int] // Date string -> XP earned that day
    let weeklyXP: [String: Int] // Week string -> XP earned that week
    let monthlyXP: [String: Int] // Month string -> XP earned that month
    let lessonHistory: [LessonSession]
    let streakHistory: [StreakRecord]
    let accuracyHistory: [AccuracyRecord]
    
    init(uid: String) {
        self.uid = uid
        self.dailyXP = [:]
        self.weeklyXP = [:]
        self.monthlyXP = [:]
        self.lessonHistory = []
        self.streakHistory = []
        self.accuracyHistory = []
    }
}

struct LessonSession: Codable, Identifiable {
    let id = UUID()
    let lessonId: String
    let language: String
    let xpEarned: Int
    let accuracy: Double
    let timeSpent: Int // in seconds
    let completedAt: Date
    let mistakes: [String]
}

struct StreakRecord: Codable, Identifiable {
    let id = UUID()
    let streakCount: Int
    let startDate: Date
    let endDate: Date?
    let isActive: Bool
}

struct AccuracyRecord: Codable, Identifiable {
    let id = UUID()
    let date: Date
    let accuracy: Double
    let lessonType: String
}

// MARK: - Achievement Model

struct Achievement: Codable, Identifiable, Equatable {
    let id: String
    let title: String
    let description: String
    let iconName: String
    let category: AchievementCategory
    let requirement: Int
    let xpReward: Int
    let isUnlocked: Bool
    let unlockedAt: Date?
    
    enum AchievementCategory: String, CaseIterable, Codable {
        case streak = "streak"
        case xp = "xp"
        case lessons = "lessons"
        case accuracy = "accuracy"
        case social = "social"
        case time = "time"
        
        var displayName: String {
            switch self {
            case .streak: return "Streak"
            case .xp: return "Experience"
            case .lessons: return "Lessons"
            case .accuracy: return "Accuracy"
            case .social: return "Social"
            case .time: return "Time"
            }
        }
        
        var color: String {
            switch self {
            case .streak: return "#FF6B35"
            case .xp: return "#4ECDC4"
            case .lessons: return "#45B7D1"
            case .accuracy: return "#96CEB4"
            case .social: return "#FFEAA7"
            case .time: return "#DDA0DD"
            }
        }
    }
}

