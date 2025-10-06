//
//  LanguageSelectionView.swift
//  FigmaProject
//
//  Created by Sarp Ugrasiz on 14.08.2025.
//

import SwiftUI

struct Language {
    let name: String
    let flagImage: String
    let id = UUID()
}

struct LanguageSelectionView: View {
    @EnvironmentObject var firebaseManager: FirebaseManager
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var sessionManager: UserSessionManager
    @EnvironmentObject var databaseManager: DatabaseManager
    @State private var searchText: String = ""
    @State private var selectedLanguage: Language?
    @State private var navigateToMainTab = false
    
    let allLanguages = [
        Language(name: "Spanish", flagImage: "spanish_flag"),
        Language(name: "French", flagImage: "french_flag"),
        Language(name: "German", flagImage: "german_flag"),
        Language(name: "Italian", flagImage: "italian_flag"),
        Language(name: "Japanese", flagImage: "japanese_flag"),
        Language(name: "Korean", flagImage: "korean_flag"),
        Language(name: "Arabic", flagImage: "arabic_flag"),
        Language(name: "Chinese", flagImage: "chinese_flag"),
        Language(name: "Dutch", flagImage: "dutch_flag"),
        Language(name: "Greek", flagImage: "greek_flag"),
        Language(name: "Hindi", flagImage: "hindi_flag"),
        Language(name: "Irish", flagImage: "irish_flag"),
        Language(name: "Portuguese", flagImage: "portuguese_flag"),
        Language(name: "Russian", flagImage: "russian_flag"),
        Language(name: "Swedish", flagImage: "swedish_flag"),
        Language(name: "Turkish", flagImage: "turkish_flag")
    ]
    
    var popularLanguages: [Language] {
        Array(allLanguages.prefix(6))
    }
    
    var filteredLanguages: [Language] {
        if searchText.isEmpty {
            return allLanguages
        } else {
            return allLanguages.filter { language in
                language.name.lowercased().hasPrefix(searchText.lowercased())
            }
        }
    }
    
    var filteredPopularLanguages: [Language] {
        if searchText.isEmpty {
            return popularLanguages
        } else {
            return popularLanguages.filter { language in
                language.name.lowercased().hasPrefix(searchText.lowercased())
            }
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background
                AppColors.background(for: themeManager.isDarkMode)
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header
                    VStack(spacing: 0) {
                        // Top header with title and close button
                        HStack {
                            Spacer()
                            
                            Text("Learn a language")
                                .font(.system(size: 18, weight: .bold, design: .default))
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            Button(action: {
                                // Close action
                            }) {
                                Image(systemName: "xmark")
                                    .font(.system(size: 18, weight: .medium))
                                    .foregroundColor(.white)
                                    .frame(width: 24, height: 24)
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 16)
                        .padding(.bottom, 8)
                        
                        // Search bar
                        HStack(spacing: 0) {
                            HStack {
                                Image(systemName: "magnifyingglass")
                                    .font(.system(size: 16))
                                    .foregroundColor(AppColors.secondaryText(for: themeManager.isDarkMode))
                                    .padding(.leading, 16)
                                
                                TextField("Search for a language", text: $searchText)
                                    .font(.system(size: 16, weight: .regular, design: .default))
                                    .foregroundColor(AppColors.secondaryText(for: themeManager.isDarkMode))
                                    .padding(.trailing, 16)
                                    .padding(.vertical, 8)
                            }
                            .background(Color(hex: "#293338"))
                            .cornerRadius(12)
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, 12)
                    }
                    
                    // Scrollable content
                    ScrollView {
                        VStack(alignment: .leading, spacing: 20) {
                            // Popular section (only show when search is empty)
                            if searchText.isEmpty {
                                VStack(alignment: .leading, spacing: 12) {
                                    HStack {
                                        Text("Popular")
                                            .font(.system(size: 22, weight: .bold, design: .default))
                                            .foregroundColor(.white)
                                            .padding(.horizontal, 16)
                                        Spacer()
                                    }
                                    
                                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 2), spacing: 12) {
                                        ForEach(filteredPopularLanguages, id: \.id) { language in
                                            LanguageCard(language: language, isSelected: selectedLanguage?.name == language.name) {
                                                selectedLanguage = language
                                            }
                                        }
                                    }
                                    .padding(.horizontal, 16)
                                }
                            }
                            
                            // All languages section
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    Text(searchText.isEmpty ? "All languages" : "Search results")
                                        .font(.system(size: 22, weight: .bold, design: .default))
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 16)
                                    Spacer()
                                }
                                
                                if filteredLanguages.isEmpty && !searchText.isEmpty {
                                    Text("No languages found")
                                        .font(.system(size: 16, weight: .regular, design: .default))
                                        .foregroundColor(AppColors.secondaryText(for: themeManager.isDarkMode))
                                        .padding(.horizontal, 16)
                                        .padding(.top, 20)
                                } else {
                                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 2), spacing: 12) {
                                        ForEach(filteredLanguages, id: \.id) { language in
                                            LanguageCard(language: language, isSelected: selectedLanguage?.name == language.name) {
                                                selectedLanguage = language
                                            }
                                        }
                                    }
                                    .padding(.horizontal, 16)
                                }
                            }
                            
                            // Bottom padding for tab bar
                            Spacer()
                                .frame(height: 120)
                        }
                        .padding(.top, 20)
                    }
                    
                    Spacer()
                }
                
                // Bottom section with button and tab bar
                VStack(spacing: 0) {
                    Spacer()
                    
                    // Start Learning Button
                                            Button(action: {
                            saveLanguageSelection()
                        }) {
                        HStack {
                            Spacer()
                            Text("Start Learning")
                                .font(.system(size: 16, weight: .bold, design: .default))
                                .foregroundColor(.white)
                            Spacer()
                        }
                        .frame(height: 48)
                        .background(Color(hex: "#2699E8"))
                        .cornerRadius(24)
                        .padding(.horizontal, 16)
                    }
                    .padding(.bottom, 12)
                    .disabled(selectedLanguage == nil)
                    .opacity(selectedLanguage == nil ? 0.6 : 1.0)
                    
                    // Bottom Tab Bar
                    HStack(spacing: 8) {
                        TabBarItem(icon: "house.fill", title: "Home", isSelected: true)
                        TabBarItem(icon: "book", title: "Lessons", isSelected: false)
                        TabBarItem(icon: "chart.bar", title: "Leaderboard", isSelected: false)
                        TabBarItem(icon: "person", title: "Profile", isSelected: false)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color(hex: "#1C2126"))
                    .overlay(
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(Color(hex: "#293338")),
                        alignment: .top
                    )
                }
            }
        }
        .ignoresSafeArea(.all)
        .navigationDestination(isPresented: $navigateToMainTab) {
            MainTabView()
        }
    }
    
    // MARK: - Firebase Methods
    
    private func saveLanguageSelection() {
        guard let selectedLanguage = selectedLanguage else { return }
        
        // Local storage (backup)
        UserDefaults.standard.set(selectedLanguage.name, forKey: "selectedLanguage")
        
        // Firebase'e kaydet
        Task {
            do {
                try await firebaseManager.updateUserLanguage(selectedLanguage.name)
                await MainActor.run {
                    navigateToMainTab = true
                }
            } catch {
                print("Error saving language: \(error)")
                // Hata olsa bile devam et
                await MainActor.run {
                    navigateToMainTab = true
                }
            }
        }
    }
}

struct LanguageCard: View {
    @EnvironmentObject var themeManager: ThemeManager
    let language: Language
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 12) {
                // Flag container
                ZStack {
                    Circle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 70, height: 70)
                    
                    Image(language.flagImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 70, height: 70)
                        .clipShape(Circle())
                }
                
                // Language name
                Text(language.name)
                    .font(.system(size: 16, weight: .medium, design: .default))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
            }
            .padding(.bottom, 12)
        }
        .buttonStyle(PlainButtonStyle())
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(isSelected ? Color(hex: "#2699E8").opacity(0.2) : Color.clear)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(isSelected ? Color(hex: "#2699E8") : Color.clear, lineWidth: 2)
                )
        )
    }
}

struct TabBarItem: View {
    @EnvironmentObject var themeManager: ThemeManager
    let icon: String
    let title: String
    let isSelected: Bool
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(isSelected ? .white : AppColors.secondaryText(for: themeManager.isDarkMode))
                .frame(height: 32)
            
            Text(title)
                .font(.system(size: 12, weight: .medium, design: .default))
                .foregroundColor(isSelected ? .white : AppColors.secondaryText(for: themeManager.isDarkMode))
        }
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 27)
                .fill(isSelected ? Color.clear : Color.clear)
        )
    }
}

// Color extension (if not already present)
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

#Preview {
    LanguageSelectionView()
}
