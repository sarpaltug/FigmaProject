//
//  AboutView.swift
//  FigmaProject
//
//  Created by Sarp Ugrasiz on 27.08.2025.
//

import SwiftUI

struct AboutView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var showTermsOfService = false
    
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
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(.white)
                        }
                        
                        Spacer()
                        
                        // Title
                        Text("Stitch - Design with AI")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        // Balance space for centering
                        Rectangle()
                            .fill(Color.clear)
                            .frame(width: 18, height: 18)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    
                    // Main content
                    ScrollView {
                        VStack(spacing: 24) {
                            // Sloth illustration
                            SlothIllustrationLarge()
                                .frame(width: 280, height: 320)
                                .padding(.top, 40)
                            
                            // Main message
                            VStack(spacing: 16) {
                                Text("Learn languages for free.")
                                    .font(.system(size: 28, weight: .bold))
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.center)
                                
                                Text("Forever.")
                                    .font(.system(size: 28, weight: .bold))
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.center)
                            }
                            .padding(.horizontal, 20)
                            
                            // Description
                            Text("Fun, effective, and 100% free. Learn a new language with game-like lessons and a global community of learners.")
                                .font(.system(size: 16, weight: .regular))
                                .foregroundColor(Color(hex: "#9EADB8"))
                                .multilineTextAlignment(.center)
                                .lineSpacing(4)
                                .padding(.horizontal, 30)
                            
                            // Version section
                            VStack(spacing: 12) {
                                Text("Version")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.white)
                                
                                Text("1.0.0")
                                    .font(.system(size: 16, weight: .regular))
                                    .foregroundColor(Color(hex: "#9EADB8"))
                            }
                            .padding(.top, 20)
                            
                            // Legal section
                            VStack(spacing: 16) {
                                Text("Legal")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.white)
                                
                                VStack(spacing: 12) {
                                    Button(action: {
                                        showTermsOfService = true
                                    }) {
                                        Text("Terms of Service")
                                            .font(.system(size: 16, weight: .regular))
                                            .foregroundColor(Color(hex: "#9EADB8"))
                                    }
                                    
                                    Button(action: {
                                        // Handle Privacy Policy
                                    }) {
                                        Text("Privacy Policy")
                                            .font(.system(size: 16, weight: .regular))
                                            .foregroundColor(Color(hex: "#9EADB8"))
                                    }
                                }
                            }
                            .padding(.top, 12)
                            
                            // Bottom spacing
                            Spacer()
                                .frame(height: 40)
                        }
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .navigationDestination(isPresented: $showTermsOfService) {
            TermsOfServiceView()
        }
    }
}

struct SlothIllustrationLarge: View {
    var body: some View {
        ZStack {
            // Sloth illustration - using a larger version
            Image(systemName: "tortoise.fill")
                .font(.system(size: 200))
                .foregroundColor(Color(hex: "#8B6F47"))
                .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
        }
    }
}

#Preview {
    AboutView()
}
