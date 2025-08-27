//
//  TermsOfServiceView.swift
//  FigmaProject
//
//  Created by Sarp Ugrasiz on 27.08.2025.
//

import SwiftUI

struct TermsOfServiceView: View {
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
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(.white)
                        }
                        
                        Spacer()
                        
                        // Title
                        Text("Terms of Service")
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
                            // Subtitle in frame
                            HStack {
                                Text("Stitch - Design with AI")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.white.opacity(0.3), lineWidth: 1)
                                    )
                            }
                            .padding(.top, 20)
                            
                            // Sloth illustration in green frame
                            ZStack {
                                // Green rounded rectangle background
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color(hex: "#4A5D4F"))
                                    .frame(width: 300, height: 320)
                                
                                // Sloth illustration
                                SlothIllustrationFramed()
                                    .frame(width: 250, height: 280)
                            }
                            .padding(.top, 10)
                            
                            // Terms text
                            VStack(spacing: 16) {
                                Text("Welcome to our language learning app! By using our app, you agree to these terms. Please read them carefully. If you do not agree, do not use the app. We may update these terms, so check back regularly. Your continued use means you accept the changes. Our app provides language lessons and features. We grant you a limited license to use it for personal, non-commercial purposes. You must not misuse the app, such as by copying content or interfering with its operation. We are not liable for any issues arising from your use of the app. These terms are governed by the laws of the jurisdiction where our company is based. If you have questions, contact us at support@example.com.")
                                    .font(.system(size: 14, weight: .regular))
                                    .foregroundColor(Color(hex: "#9EADB8"))
                                    .multilineTextAlignment(.leading)
                                    .lineSpacing(4)
                                    .padding(.horizontal, 20)
                            }
                            .padding(.top, 10)
                            
                            // Accept button
                            Button(action: {
                                // Navigate back to Settings
                                presentationMode.wrappedValue.dismiss()
                            }) {
                                Text("Accept")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 50)
                                    .background(
                                        LinearGradient(
                                            gradient: Gradient(colors: [
                                                Color(hex: "#4A90E2"),
                                                Color(hex: "#357ABD")
                                            ]),
                                            startPoint: .top,
                                            endPoint: .bottom
                                        )
                                    )
                                    .cornerRadius(25)
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 30)
                            
                            // Bottom spacing
                            Spacer()
                                .frame(height: 40)
                        }
                    }
                }
            }
        }
        .navigationBarHidden(true)
    }
}

struct SlothIllustrationFramed: View {
    var body: some View {
        ZStack {
            // Sloth illustration - using a detailed sloth representation
            Image(systemName: "tortoise.fill")
                .font(.system(size: 160))
                .foregroundColor(Color(hex: "#8B6F47"))
                .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)
        }
    }
}

#Preview {
    TermsOfServiceView()
}
