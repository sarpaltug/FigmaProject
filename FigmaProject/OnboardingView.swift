//
//  OnboardingView.swift
//  FigmaProject
//
//  Created by Sarp Ugrasiz on 14.08.2025.
//

import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var firebaseManager: FirebaseManager
    @EnvironmentObject var sessionManager: UserSessionManager
    @EnvironmentObject var databaseManager: DatabaseManager
    @State private var shouldNavigate = false
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ZStack {
                // Background
                AppColors.background(for: themeManager.isDarkMode)
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    Spacer()
                    
                    // Sloth illustration container
                    ZStack {
                        // Background card
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color(hex: "#F5F3F0"))
                            .frame(width: min(geometry.size.width - 40, 350), height: 400)
                        
                        // Sloth illustration
                        SlothIllustration()
                            .frame(width: min(geometry.size.width - 80, 300), height: 350)
                    }
                    .padding(.bottom, 40)
                    
                    // Title
                    Text("Learn a language for free")
                        .font(.system(size: 28, weight: .bold, design: .default))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 16)
                    
                    // Subtitle
                    Text("Learning with us is fun, and research shows that it works!")
                        .font(.system(size: 16, weight: .regular, design: .default))
                        .foregroundColor(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                        .padding(.bottom, 40)
                    
                    // Get started button with auto navigation
                    Button(action: {
                        shouldNavigate = true
                    }) {
                        HStack {
                            Spacer()
                            Text("Get started")
                                .font(.system(size: 18, weight: .bold, design: .default))
                                .foregroundColor(.white)
                            Spacer()
                        }
                        .frame(height: 56)
                        .background(Color(hex: "#2699E8"))
                        .cornerRadius(28)
                        .padding(.horizontal, 20)
                    }
                    
                    Spacer()
                        .frame(height: 50)
                }
            }
            }
            .onAppear {
                // Otomatik olarak 2 saniye sonra navigasyon yap
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    shouldNavigate = true
                }
            }
            .navigationDestination(isPresented: $shouldNavigate) {
                ContentView()
                    .environmentObject(firebaseManager)
                    .environmentObject(themeManager)
                    .environmentObject(sessionManager)
                    .environmentObject(databaseManager)
            }
        }
    }
}

struct SlothIllustration: View {
    var body: some View {
        ZStack {
            // Sloth body
            Ellipse()
                .fill(
                    RadialGradient(
                        colors: [Color(hex: "#8B7355"), Color(hex: "#6B5B47")],
                        center: .center,
                        startRadius: 20,
                        endRadius: 120
                    )
                )
                .frame(width: 200, height: 280)
            
            // Sloth belly
            Ellipse()
                .fill(
                    LinearGradient(
                        colors: [Color(hex: "#F0E6D2"), Color(hex: "#E8DCC8")],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(width: 120, height: 180)
                .offset(y: 20)
            
            // Sloth head
            Circle()
                .fill(
                    RadialGradient(
                        colors: [Color(hex: "#8B7355"), Color(hex: "#6B5B47")],
                        center: .center,
                        startRadius: 30,
                        endRadius: 80
                    )
                )
                .frame(width: 140, height: 140)
                .offset(y: -80)
            
            // Face area
            Ellipse()
                .fill(
                    LinearGradient(
                        colors: [Color(hex: "#F0E6D2"), Color(hex: "#E8DCC8")],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(width: 100, height: 80)
                .offset(y: -70)
            
            // Eye patches
            HStack(spacing: 20) {
                Ellipse()
                    .fill(Color(hex: "#2D2D2D"))
                    .frame(width: 35, height: 40)
                Ellipse()
                    .fill(Color(hex: "#2D2D2D"))
                    .frame(width: 35, height: 40)
            }
            .offset(y: -85)
            
            // Eyes
            HStack(spacing: 20) {
                Circle()
                    .fill(Color.white)
                    .frame(width: 20, height: 20)
                    .overlay(
                        Circle()
                            .fill(Color.black)
                            .frame(width: 12, height: 12)
                    )
                Circle()
                    .fill(Color.white)
                    .frame(width: 20, height: 20)
                    .overlay(
                        Circle()
                            .fill(Color.black)
                            .frame(width: 12, height: 12)
                    )
            }
            .offset(y: -85)
            
            // Nose
            Ellipse()
                .fill(Color(hex: "#2D2D2D"))
                .frame(width: 12, height: 8)
                .offset(y: -55)
            
            // Mouth
            Path { path in
                path.move(to: CGPoint(x: -8, y: 0))
                path.addQuadCurve(to: CGPoint(x: 8, y: 0), control: CGPoint(x: 0, y: 6))
            }
            .stroke(Color(hex: "#2D2D2D"), lineWidth: 2)
            .offset(y: -45)
            
            // Arms
            HStack(spacing: 160) {
                Ellipse()
                    .fill(
                        LinearGradient(
                            colors: [Color(hex: "#8B7355"), Color(hex: "#6B5B47")],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: 40, height: 100)
                    .rotationEffect(.degrees(-15))
                
                Ellipse()
                    .fill(
                        LinearGradient(
                            colors: [Color(hex: "#8B7355"), Color(hex: "#6B5B47")],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: 40, height: 100)
                    .rotationEffect(.degrees(15))
            }
            .offset(y: -20)
        }
    }
}



#Preview {
    OnboardingView()
}
