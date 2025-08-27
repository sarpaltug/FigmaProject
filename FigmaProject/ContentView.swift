//
//  ContentView.swift
//  FigmaProject
//
//  Created by Sarp Ugrasiz on 5.08.2025.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var navigateToLanguageSelection = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background
                Color.white
                    .ignoresSafeArea()
                
                // Decorative background layers at the bottom
                VStack {
                    Spacer()
                    ZStack {
                        // Background decoration (placeholder rectangles for the SVG layers)
                        Rectangle()
                            .fill(Color.blue.opacity(0.1))
                            .frame(height: 320)
                        Rectangle()
                            .fill(Color.green.opacity(0.1))
                            .frame(height: 280)
                        Rectangle()
                            .fill(Color.purple.opacity(0.1))
                            .frame(height: 240)
                        Rectangle()
                            .fill(Color.orange.opacity(0.1))
                            .frame(height: 200)
                    }
                }
                
                // Main content
                VStack(spacing: 0) {
                    // Header
                    HStack {
                        // Logo (24x24)
                        Image("logo")
                            .resizable()
                            .frame(width: 24, height: 24)
                        
                        Spacer()
                        
                        // Sign up text
                        Text("Sign up")
                            .font(.system(size: 18, weight: .bold, design: .default))
                            .foregroundColor(Color(hex: "#121417"))
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                    .padding(.bottom, 8)
                    
                    // Form fields
                    VStack(spacing: 16) {
                        // Name field
                        TextField("Name", text: $name)
                            .font(.system(size: 16, weight: .regular, design: .default))
                            .foregroundColor(Color(hex: "#637887"))
                            .padding(16)
                            .background(Color(hex: "#F0F2F5"))
                            .cornerRadius(12)
                            .padding(.horizontal, 16)
                        
                        // Email field
                        TextField("Email", text: $email)
                            .font(.system(size: 16, weight: .regular, design: .default))
                            .foregroundColor(Color(hex: "#637887"))
                            .padding(16)
                            .background(Color(hex: "#F0F2F5"))
                            .cornerRadius(12)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .padding(.horizontal, 16)
                        
                        // Password field
                        SecureField("Password", text: $password)
                            .font(.system(size: 16, weight: .regular, design: .default))
                            .foregroundColor(Color(hex: "#637887"))
                            .padding(16)
                            .background(Color(hex: "#F0F2F5"))
                            .cornerRadius(12)
                            .padding(.horizontal, 16)
                        
                        // Create account button
                        Button(action: {
                            // Save the user name when creating account
                            UserDefaults.standard.set(name, forKey: "userName")
                            navigateToLanguageSelection = true
                        }) {
                            HStack {
                                Spacer()
                                Text("Create account")
                                    .font(.system(size: 16, weight: .bold, design: .default))
                                    .foregroundColor(.white)
                                Spacer()
                            }
                            .frame(height: 48)
                            .background(Color(hex: "#2699E8"))
                            .cornerRadius(24)
                            .padding(.horizontal, 20)
                        }
                        .padding(.horizontal, 16)
                    }
                    .padding(.vertical, 12)
                    
                    Spacer()
                }
            }
        }
        .frame(maxWidth: 390) // Max width as per Figma design, but responsive
        .navigationDestination(isPresented: $navigateToLanguageSelection) {
            LanguageSelectionView()
        }
    }
    

    

}



#Preview {
    ContentView()
}
