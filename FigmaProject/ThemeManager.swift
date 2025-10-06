//
//  ThemeManager.swift
//  FigmaProject
//
//  Created by Sarp Ugrasiz on 27.08.2025.
//

import SwiftUI
import Combine

// MARK: - Theme Enum
enum AppTheme: String, CaseIterable {
    case light = "light"
    case dark = "dark"
    case system = "system"
    
    var displayName: String {
        switch self {
        case .light: return "Light"
        case .dark: return "Dark"
        case .system: return "System"
        }
    }
}

// MARK: - Theme Manager
class ThemeManager: ObservableObject {
    static let shared = ThemeManager()
    
    @Published var currentTheme: AppTheme {
        didSet {
            UserDefaults.standard.set(currentTheme.rawValue, forKey: "selectedTheme")
            applyTheme()
        }
    }
    
    @Published var isDarkMode: Bool = false
    
    init() {
        // Load saved theme or default to system
        let savedTheme = UserDefaults.standard.string(forKey: "selectedTheme") ?? AppTheme.system.rawValue
        self.currentTheme = AppTheme(rawValue: savedTheme) ?? .system
        
        applyTheme()
    }
    
    private func applyTheme() {
        switch currentTheme {
        case .light:
            isDarkMode = false
        case .dark:
            isDarkMode = true
        case .system:
            isDarkMode = UITraitCollection.current.userInterfaceStyle == .dark
        }
    }
    
    func toggleTheme() {
        switch currentTheme {
        case .light:
            currentTheme = .dark
        case .dark:
            currentTheme = .light
        case .system:
            currentTheme = .light
        }
    }
}

// MARK: - App Colors
struct AppColors {
    static func background(for isDarkMode: Bool) -> Color {
        isDarkMode ? Color(hex: "#1C1C1E") : Color.white
    }
    
    static func secondaryBackground(for isDarkMode: Bool) -> Color {
        isDarkMode ? Color(hex: "#2C2C2E") : Color(hex: "#F2F2F7")
    }
    
    static func primaryText(for isDarkMode: Bool) -> Color {
        isDarkMode ? Color.white : Color.black
    }
    
    static func secondaryText(for isDarkMode: Bool) -> Color {
        isDarkMode ? Color(hex: "#8E8E93") : Color(hex: "#6D6D70")
    }
    
    static func accent(for isDarkMode: Bool) -> Color {
        isDarkMode ? Color(hex: "#007AFF") : Color(hex: "#2699E8")
    }
    
    static func cardBackground(for isDarkMode: Bool) -> Color {
        isDarkMode ? Color(hex: "#2C2C2E") : Color.white
    }
    
    static func border(for isDarkMode: Bool) -> Color {
        isDarkMode ? Color(hex: "#38383A") : Color(hex: "#E5E5EA")
    }
    
    static func success(for isDarkMode: Bool) -> Color {
        isDarkMode ? Color(hex: "#30D158") : Color(hex: "#34C759")
    }
    
    static func warning(for isDarkMode: Bool) -> Color {
        isDarkMode ? Color(hex: "#FF9F0A") : Color(hex: "#FF9500")
    }
    
    static func danger(for isDarkMode: Bool) -> Color {
        isDarkMode ? Color(hex: "#FF453A") : Color(hex: "#FF3B30")
    }
}

// Color extension zaten LanguageSelectionView.swift'te tanımlı, duplicate'i kaldırıyoruz
