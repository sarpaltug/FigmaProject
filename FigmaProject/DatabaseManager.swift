//
//  DatabaseManager.swift
//  FigmaProject
//
//  Created by Sarp Ugrasiz on 27.08.2025.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import SwiftUI

class DatabaseManager: ObservableObject {
    static let shared = DatabaseManager()
    
    private let db = Firestore.firestore()
    private let sessionManager = UserSessionManager.shared
    
    // MARK: - Published Properties
    @Published var currentUserProfile: UserProfileModel?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    // MARK: - Collections
    private let usersCollection = "users"
    private let statisticsCollection = "user_statistics"
    private let achievementsCollection = "achievements"
    private let leaderboardCollection = "leaderboard"
    
    private init() {
        setupFirestore()
    }
    
    private func setupFirestore() {
        // Enable offline persistence
        let settings = FirestoreSettings()
        settings.isPersistenceEnabled = true
        settings.cacheSizeBytes = FirestoreCacheSizeUnlimited
        db.settings = settings
    }
    
    // MARK: - User Profile Operations
    
    func createUserProfile(_ profile: UserProfileModel) async throws {
        isLoading = true
        defer { isLoading = false }
        
        do {
            try await db.collection(usersCollection)
                .document(profile.uid)
                .setData(profile.toDictionary())
            
            await MainActor.run {
                self.currentUserProfile = profile
            }
            
            // Create initial statistics
            try await createUserStatistics(for: profile.uid)
            
        } catch {
            await MainActor.run {
                self.errorMessage = "Failed to create user profile: \(error.localizedDescription)"
            }
            throw error
        }
    }
    
    func getUserProfile(uid: String) async throws -> UserProfileModel? {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let document = try await db.collection(usersCollection)
                .document(uid)
                .getDocument()
            
            guard let data = document.data() else {
                return nil
            }
            
            let profile = UserProfileModel(data: data)
            
            await MainActor.run {
                self.currentUserProfile = profile
            }
            
            return profile
            
        } catch {
            await MainActor.run {
                self.errorMessage = "Failed to get user profile: \(error.localizedDescription)"
            }
            throw error
        }
    }
    
    func updateUserProfile(_ profile: UserProfileModel) async throws {
        isLoading = true
        defer { isLoading = false }
        
        do {
            var updatedData = profile.toDictionary()
            updatedData["updatedAt"] = Timestamp(date: Date())
            
            try await db.collection(usersCollection)
                .document(profile.uid)
                .updateData(updatedData)
            
            await MainActor.run {
                self.currentUserProfile = profile
            }
            
            // Update session manager
            let legacyProfile = UserProfile(data: updatedData)
            sessionManager.updateUserProfile(legacyProfile)
            
        } catch {
            await MainActor.run {
                self.errorMessage = "Failed to update user profile: \(error.localizedDescription)"
            }
            throw error
        }
    }
    
    func updateUserXP(uid: String, xpToAdd: Int) async throws {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let userRef = db.collection(usersCollection).document(uid)
            
            try await db.runTransaction { transaction, errorPointer in
                let userDocument: DocumentSnapshot
                do {
                    userDocument = try transaction.getDocument(userRef)
                } catch let fetchError as NSError {
                    errorPointer?.pointee = fetchError
                    return nil
                }
                
                guard let data = userDocument.data() else {
                    let error = NSError(domain: "DatabaseError", code: -1, userInfo: [NSLocalizedDescriptionKey: "User document not found"])
                    errorPointer?.pointee = error
                    return nil
                }
                
                let currentXP = data["totalXP"] as? Int ?? 0
                let newTotalXP = currentXP + xpToAdd
                let newLevel = UserProfileModel.calculateLevel(from: newTotalXP)
                
                transaction.updateData([
                    "totalXP": newTotalXP,
                    "currentLevel": newLevel,
                    "updatedAt": Timestamp(date: Date()),
                    "lastStudyAt": Timestamp(date: Date())
                ], forDocument: userRef)
                
                return newTotalXP
            }
            
            // Update current profile
            if var profile = currentUserProfile {
                let newTotalXP = profile.totalXP + xpToAdd
                let updatedProfile = UserProfileModel(data: [
                    "uid": profile.uid,
                    "email": profile.email,
                    "displayName": profile.displayName,
                    "selectedLanguage": profile.selectedLanguage,
                    "totalXP": newTotalXP,
                    "currentLevel": UserProfileModel.calculateLevel(from: newTotalXP),
                    "completedLessons": profile.completedLessons,
                    "currentStreak": profile.currentStreak,
                    "longestStreak": profile.longestStreak,
                    "createdAt": profile.createdAt,
                    "updatedAt": Date(),
                    "lastLoginAt": profile.lastLoginAt,
                    "lastStudyAt": Date()
                ])
                
                await MainActor.run {
                    self.currentUserProfile = updatedProfile
                }
            }
            
        } catch {
            await MainActor.run {
                self.errorMessage = "Failed to update XP: \(error.localizedDescription)"
            }
            throw error
        }
    }
    
    func updateUserLanguage(uid: String, language: String) async throws {
        do {
            try await db.collection(usersCollection)
                .document(uid)
                .updateData([
                    "selectedLanguage": language,
                    "updatedAt": Timestamp(date: Date())
                ])
            
            // Update current profile
            if var profile = currentUserProfile {
                let updatedData = profile.toDictionary()
                var newData = updatedData
                newData["selectedLanguage"] = language
                newData["updatedAt"] = Timestamp(date: Date())
                
                let updatedProfile = UserProfileModel(data: newData)
                
                await MainActor.run {
                    self.currentUserProfile = updatedProfile
                }
            }
            
        } catch {
            await MainActor.run {
                self.errorMessage = "Failed to update language: \(error.localizedDescription)"
            }
            throw error
        }
    }
    
    func updateUserStreak(uid: String, newStreak: Int) async throws {
        do {
            let userRef = db.collection(usersCollection).document(uid)
            
            try await db.runTransaction { transaction, errorPointer in
                let userDocument: DocumentSnapshot
                do {
                    userDocument = try transaction.getDocument(userRef)
                } catch let fetchError as NSError {
                    errorPointer?.pointee = fetchError
                    return nil
                }
                
                guard let data = userDocument.data() else {
                    let error = NSError(domain: "DatabaseError", code: -1, userInfo: [NSLocalizedDescriptionKey: "User document not found"])
                    errorPointer?.pointee = error
                    return nil
                }
                
                let currentLongestStreak = data["longestStreak"] as? Int ?? 0
                let newLongestStreak = max(currentLongestStreak, newStreak)
                
                transaction.updateData([
                    "currentStreak": newStreak,
                    "longestStreak": newLongestStreak,
                    "updatedAt": Timestamp(date: Date())
                ], forDocument: userRef)
                
                return newStreak
            }
            
        } catch {
            await MainActor.run {
                self.errorMessage = "Failed to update streak: \(error.localizedDescription)"
            }
            throw error
        }
    }
    
    // MARK: - Statistics Operations
    
    private func createUserStatistics(for uid: String) async throws {
        let statistics = UserStatistics(uid: uid)
        
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(statistics)
            let dictionary = try JSONSerialization.jsonObject(with: data) as? [String: Any] ?? [:]
            
            try await db.collection(statisticsCollection)
                .document(uid)
                .setData(dictionary)
            
        } catch {
            print("Failed to create user statistics: \(error)")
            throw error
        }
    }
    
    func recordLessonSession(_ session: LessonSession, for uid: String) async throws {
        do {
            // Add to lesson history
            let encoder = JSONEncoder()
            let sessionData = try encoder.encode(session)
            let sessionDict = try JSONSerialization.jsonObject(with: sessionData) as? [String: Any] ?? [:]
            
            try await db.collection(statisticsCollection)
                .document(uid)
                .collection("lesson_sessions")
                .addDocument(data: sessionDict)
            
            // Update daily XP
            let today = DateFormatter.dateKey.string(from: Date())
            try await db.collection(statisticsCollection)
                .document(uid)
                .updateData([
                    "dailyXP.\(today)": FieldValue.increment(Int64(session.xpEarned))
                ])
            
        } catch {
            throw error
        }
    }
    
    // MARK: - Leaderboard Operations
    
    func getLeaderboard(limit: Int = 50) async throws -> [UserProfileModel] {
        do {
            let snapshot = try await db.collection(usersCollection)
                .whereField("isPublicProfile", isEqualTo: true)
                .order(by: "totalXP", descending: true)
                .limit(to: limit)
                .getDocuments()
            
            return snapshot.documents.compactMap { document in
                UserProfileModel(data: document.data())
            }
            
        } catch {
            await MainActor.run {
                self.errorMessage = "Failed to get leaderboard: \(error.localizedDescription)"
            }
            throw error
        }
    }
    
    func getUserRank(uid: String) async throws -> Int {
        do {
            guard let userProfile = try await getUserProfile(uid: uid) else {
                throw NSError(domain: "DatabaseError", code: -1, userInfo: [NSLocalizedDescriptionKey: "User profile not found"])
            }
            
            let snapshot = try await db.collection(usersCollection)
                .whereField("totalXP", isGreaterThan: userProfile.totalXP)
                .whereField("isPublicProfile", isEqualTo: true)
                .getDocuments()
            
            return snapshot.documents.count + 1
            
        } catch {
            throw error
        }
    }
    
    // MARK: - Achievement Operations
    
    func getAvailableAchievements() async throws -> [Achievement] {
        do {
            let snapshot = try await db.collection(achievementsCollection)
                .order(by: "requirement", descending: false)
                .getDocuments()
            
            return snapshot.documents.compactMap { document in
                let data = document.data()
                return Achievement(
                    id: document.documentID,
                    title: data["title"] as? String ?? "",
                    description: data["description"] as? String ?? "",
                    iconName: data["iconName"] as? String ?? "star.fill",
                    category: Achievement.AchievementCategory(rawValue: data["category"] as? String ?? "xp") ?? .xp,
                    requirement: data["requirement"] as? Int ?? 0,
                    xpReward: data["xpReward"] as? Int ?? 0,
                    isUnlocked: false,
                    unlockedAt: nil
                )
            }
            
        } catch {
            throw error
        }
    }
    
    func unlockAchievement(achievementId: String, for uid: String) async throws {
        do {
            try await db.collection(usersCollection)
                .document(uid)
                .updateData([
                    "unlockedAchievements": FieldValue.arrayUnion([achievementId]),
                    "totalAchievements": FieldValue.increment(Int64(1)),
                    "updatedAt": Timestamp(date: Date())
                ])
            
        } catch {
            throw error
        }
    }
    
    // MARK: - Real-time Listeners
    
    func startListeningToUserProfile(uid: String) {
        db.collection(usersCollection)
            .document(uid)
            .addSnapshotListener { [weak self] documentSnapshot, error in
                guard let self = self else { return }
                
                if let error = error {
                    DispatchQueue.main.async {
                        self.errorMessage = "Real-time sync error: \(error.localizedDescription)"
                    }
                    return
                }
                
                guard let document = documentSnapshot,
                      let data = document.data() else { return }
                
                let profile = UserProfileModel(data: data)
                
                DispatchQueue.main.async {
                    self.currentUserProfile = profile
                }
            }
    }
    
    // MARK: - Helper Methods
    
    func clearError() {
        errorMessage = nil
    }
}

// MARK: - Date Formatter Extension

extension DateFormatter {
    static let dateKey: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    static let weekKey: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-'W'ww"
        return formatter
    }()
    
    static let monthKey: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM"
        return formatter
    }()
}
