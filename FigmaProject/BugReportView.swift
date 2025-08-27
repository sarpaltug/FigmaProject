//
//  BugReportView.swift
//  FigmaProject
//
//  Created by Sarp Ugrasiz on 27.08.2025.
//

import SwiftUI

struct BugReportView: View {
    @State private var bugDescription: String = ""
    @State private var showFeedbackSuccess = false
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
                        // Close button
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Image(systemName: "xmark")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(.white)
                        }
                        
                        Spacer()
                        
                        // Title
                        Text("Stitch - Design with AI")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        // Balance space for centering
                        Rectangle()
                            .fill(Color.clear)
                            .frame(width: 18, height: 18)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    .padding(.bottom, 30)
                    
                    // Main content
                    VStack(spacing: 40) {
                        // Framed sloth illustration
                        ZStack {
                            // Frame background
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.white)
                                .frame(width: 280, height: 320)
                            
                            // Wooden frame effect
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color(hex: "#D4A574"), lineWidth: 12)
                                .frame(width: 280, height: 320)
                            
                            // Inner frame
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color(hex: "#E8C8A0"), lineWidth: 2)
                                .frame(width: 260, height: 300)
                            
                            // Sloth illustration
                            VStack(spacing: 0) {
                                // Sloth head and body
                                ZStack {
                                    // Body
                                    Ellipse()
                                        .fill(Color(hex: "#B8A082"))
                                        .frame(width: 120, height: 140)
                                        .offset(y: 20)
                                    
                                    // Head
                                    Circle()
                                        .fill(Color(hex: "#B8A082"))
                                        .frame(width: 80, height: 80)
                                        .offset(y: -10)
                                    
                                    // Face
                                    VStack(spacing: 8) {
                                        // Eyes
                                        HStack(spacing: 20) {
                                            // Left eye
                                            ZStack {
                                                Circle()
                                                    .fill(Color.white)
                                                    .frame(width: 16, height: 16)
                                                Circle()
                                                    .fill(Color.black)
                                                    .frame(width: 8, height: 8)
                                            }
                                            
                                            // Right eye
                                            ZStack {
                                                Circle()
                                                    .fill(Color.white)
                                                    .frame(width: 16, height: 16)
                                                Circle()
                                                    .fill(Color.black)
                                                    .frame(width: 8, height: 8)
                                            }
                                        }
                                        
                                        // Nose
                                        Circle()
                                            .fill(Color(hex: "#8B7355"))
                                            .frame(width: 6, height: 6)
                                        
                                        // Mouth (subtle smile)
                                        RoundedRectangle(cornerRadius: 2)
                                            .fill(Color(hex: "#8B7355"))
                                            .frame(width: 12, height: 2)
                                            .offset(y: 2)
                                    }
                                    .offset(y: -10)
                                    
                                    // Pink cheeks
                                    HStack(spacing: 60) {
                                        Circle()
                                            .fill(Color(hex: "#F4C2C2").opacity(0.6))
                                            .frame(width: 12, height: 12)
                                        
                                        Circle()
                                            .fill(Color(hex: "#F4C2C2").opacity(0.6))
                                            .frame(width: 12, height: 12)
                                    }
                                    .offset(y: -5)
                                    
                                    // Arms
                                    HStack(spacing: 100) {
                                        // Left arm
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(Color(hex: "#B8A082"))
                                            .frame(width: 16, height: 40)
                                            .rotationEffect(.degrees(-20))
                                        
                                        // Right arm
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(Color(hex: "#B8A082"))
                                            .frame(width: 16, height: 40)
                                            .rotationEffect(.degrees(20))
                                    }
                                    .offset(y: 15)
                                    
                                    // Legs/feet
                                    HStack(spacing: 40) {
                                        // Left foot
                                        Ellipse()
                                            .fill(Color(hex: "#E8C8A0"))
                                            .frame(width: 20, height: 12)
                                        
                                        // Right foot
                                        Ellipse()
                                            .fill(Color(hex: "#E8C8A0"))
                                            .frame(width: 20, height: 12)
                                    }
                                    .offset(y: 65)
                                }
                            }
                            .frame(width: 200, height: 200)
                        }
                        .padding(.top, 20)
                        
                        Spacer()
                        
                        // Bug description text area
                        VStack(alignment: .leading, spacing: 12) {
                            ZStack(alignment: .topLeading) {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color(hex: "#2A2E35"))
                                    .frame(height: 120)
                                
                                if bugDescription.isEmpty {
                                    Text("Describe the bug")
                                        .font(.system(size: 16))
                                        .foregroundColor(Color.gray)
                                        .padding(.horizontal, 16)
                                        .padding(.top, 16)
                                }
                                
                                TextEditor(text: $bugDescription)
                                    .font(.system(size: 16))
                                    .foregroundColor(.white)
                                    .background(Color.clear)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 12)
                                    .scrollContentBackground(.hidden)
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        // Submit button
                        Button(action: {
                            submitBugReport()
                        }) {
                            HStack {
                                Spacer()
                                Text("Submit")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.white)
                                Spacer()
                            }
                            .padding(.vertical, 16)
                            .background(Color(hex: "#4A9EFF"))
                            .cornerRadius(12)
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 30)
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .navigationDestination(isPresented: $showFeedbackSuccess) {
            FeedbackSuccessView()
        }
    }
    
    private func submitBugReport() {
        // Here you would normally send the bug report to your backend
        // For now, we'll just show the success screen
        showFeedbackSuccess = true
    }
}

struct FeedbackSuccessView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background
                Color(hex: "#121417")
                    .ignoresSafeArea()
                
                VStack(spacing: 40) {
                    Spacer()
                    
                    // Success message
                    VStack(spacing: 20) {
                        // Checkmark icon
                        ZStack {
                            Circle()
                                .fill(Color(hex: "#4CAF50"))
                                .frame(width: 80, height: 80)
                            
                            Image(systemName: "checkmark")
                                .font(.system(size: 40, weight: .bold))
                                .foregroundColor(.white)
                        }
                        
                        Text("Thanks for your feedback!")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                    }
                    
                    Spacer()
                    
                    // Go Back button
                    Button(action: {
                        // Navigate back to home (MainTabView)
                        // We'll dismiss all the way back to the tab view
                        navigateToHome()
                    }) {
                        HStack {
                            Spacer()
                            Text("Go Back")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                            Spacer()
                        }
                        .padding(.vertical, 16)
                        .background(Color(hex: "#4A9EFF"))
                        .cornerRadius(12)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 50)
                }
            }
        }
        .navigationBarHidden(true)
    }
    
    private func navigateToHome() {
        // Dismiss all presented views to go back to MainTabView
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController?.dismiss(animated: true, completion: nil)
        }
    }
}

#Preview {
    BugReportView()
}
