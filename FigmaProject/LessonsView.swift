//
//  LessonsView.swift
//  FigmaProject
//
//  Created by Sarp Ugrasiz on 27.08.2025.
//

import SwiftUI

struct Lesson {
    let id: Int
    let title: String
    let lessonNumber: String
    let isCompleted: Bool
}

struct LessonsView: View {
    let selectedLanguage: String
    @State private var lessons: [Lesson] = []
    @State private var earnedXP: Int = 20
    @State private var lessonsUntilNext: Int = 0
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
                        // Back button
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 20, weight: .medium))
                                .foregroundColor(.white)
                        }
                        
                        Spacer()
                        
                        // Language title
                        Text(selectedLanguage)
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        // Settings icon placeholder
                        Button(action: {}) {
                            Image(systemName: "gearshape")
                                .font(.system(size: 20))
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    
                    // XP Progress
                    VStack(spacing: 8) {
                        Text("\(earnedXP) XP until next lesson")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.white.opacity(0.8))
                        
                        // Progress bar
                        GeometryReader { progressGeometry in
                            ZStack(alignment: .leading) {
                                Rectangle()
                                    .fill(Color.white.opacity(0.2))
                                    .frame(height: 8)
                                    .cornerRadius(4)
                                
                                Rectangle()
                                    .fill(Color(hex: "#2699E8"))
                                    .frame(width: progressGeometry.size.width * 0.3, height: 8)
                                    .cornerRadius(4)
                            }
                        }
                        .frame(height: 8)
                        .padding(.horizontal, 20)
                    }
                    .padding(.top, 20)
                    
                    // Unit header
                    HStack {
                        Text("Unit 1: Greetings")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 30)
                    
                    // Lessons List
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(lessons, id: \.id) { lesson in
                                LessonRow(lesson: lesson)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                    }
                    
                    Spacer()
                    
                    // Bottom Navigation
                    HStack {
                        BottomNavButton(icon: "house.fill", title: "Home", isSelected: false)
                        Spacer()
                        BottomNavButton(icon: "book.fill", title: "Lessons", isSelected: true)
                        Spacer()
                        BottomNavButton(icon: "chart.bar.fill", title: "Leaderboard", isSelected: false)
                        Spacer()
                        BottomNavButton(icon: "person.fill", title: "Profile", isSelected: false)
                    }
                    .padding(.horizontal, 40)
                    .padding(.bottom, 30)
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            loadLessons()
        }
    }
    
    private func loadLessons() {
        // Load lessons based on selected language
        lessons = getLessonsForLanguage(selectedLanguage)
    }
    
    private func getLessonsForLanguage(_ language: String) -> [Lesson] {
        // Base lessons that work for all languages
        return [
            Lesson(id: 1, title: "Hello", lessonNumber: "Lesson 1", isCompleted: true),
            Lesson(id: 2, title: "Goodbye", lessonNumber: "Lesson 2", isCompleted: true),
            Lesson(id: 3, title: "How are you?", lessonNumber: "Lesson 3", isCompleted: true),
            Lesson(id: 4, title: "What's your name?", lessonNumber: "Lesson 4", isCompleted: true),
            Lesson(id: 5, title: "Where are you from?", lessonNumber: "Lesson 5", isCompleted: true),
            Lesson(id: 6, title: "Nice to meet you", lessonNumber: "Lesson 6", isCompleted: true),
            Lesson(id: 7, title: "Numbers 1-10", lessonNumber: "Lesson 7", isCompleted: true),
            Lesson(id: 8, title: "Colors", lessonNumber: "Lesson 8", isCompleted: true),
            Lesson(id: 9, title: "Animals", lessonNumber: "Lesson 9", isCompleted: true),
            Lesson(id: 10, title: "Food", lessonNumber: "Lesson 10", isCompleted: true),
            Lesson(id: 11, title: "Drinks", lessonNumber: "Lesson 11", isCompleted: true),
            Lesson(id: 12, title: "Family", lessonNumber: "Lesson 12", isCompleted: true),
            Lesson(id: 13, title: "Friends", lessonNumber: "Lesson 13", isCompleted: true),
            Lesson(id: 14, title: "Jobs", lessonNumber: "Lesson 14", isCompleted: true),
            Lesson(id: 15, title: "Hobbies", lessonNumber: "Lesson 15", isCompleted: true),
            Lesson(id: 16, title: "Weather", lessonNumber: "Lesson 16", isCompleted: true),
            Lesson(id: 17, title: "Time", lessonNumber: "Lesson 17", isCompleted: true),
            Lesson(id: 18, title: "Days of the week", lessonNumber: "Lesson 18", isCompleted: true),
            Lesson(id: 19, title: "Months of the year", lessonNumber: "Lesson 19", isCompleted: true),
            Lesson(id: 20, title: "Seasons", lessonNumber: "Lesson 20", isCompleted: true)
        ]
    }
}

struct LessonRow: View {
    let lesson: Lesson
    
    var body: some View {
        HStack(spacing: 16) {
            // Checkmark
            ZStack {
                Circle()
                    .fill(lesson.isCompleted ? Color(hex: "#4CAF50") : Color.white.opacity(0.2))
                    .frame(width: 24, height: 24)
                
                if lesson.isCompleted {
                    Image(systemName: "checkmark")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.white)
                }
            }
            
            // Lesson content
            VStack(alignment: .leading, spacing: 4) {
                Text(lesson.title)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)
                
                Text(lesson.lessonNumber)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.white.opacity(0.6))
            }
            
            Spacer()
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(hex: "#293338"))
        )
    }
}

struct BottomNavButton: View {
    let icon: String
    let title: String
    let isSelected: Bool
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(isSelected ? Color(hex: "#2699E8") : .white.opacity(0.6))
            
            Text(title)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(isSelected ? Color(hex: "#2699E8") : .white.opacity(0.6))
        }
    }
}


