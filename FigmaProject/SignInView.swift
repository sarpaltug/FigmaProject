//
//  SignInView.swift
//  FigmaProject
//
//  Created by Sarp Ugrasiz on 27.08.2025.
//

import SwiftUI

struct SignInView: View {
    @EnvironmentObject var firebaseManager: FirebaseManager
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isLoading = false
    @State private var errorMessage = ""
    @State private var showError = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background
                Color.white
                    .ignoresSafeArea()
                
                VStack(spacing: 24) {
                    Spacer()
                    
                    // Title
                    VStack(spacing: 8) {
                        Text("Welcome Back!")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.black)
                        
                        Text("Sign in to continue your learning journey")
                            .font(.system(size: 16, weight: .regular))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.horizontal, 32)
                    
                    // Sign in form
                    VStack(spacing: 16) {
                        // Email field
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Email")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.black)
                            
                            TextField("Enter your email", text: $email)
                                .textFieldStyle(PlainTextFieldStyle())
                                .font(.system(size: 16))
                                .padding(16)
                                .background(Color(hex: "#F0F2F5"))
                                .cornerRadius(12)
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                        }
                        
                        // Password field
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Password")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.black)
                            
                            SecureField("Enter your password", text: $password)
                                .textFieldStyle(PlainTextFieldStyle())
                                .font(.system(size: 16))
                                .padding(16)
                                .background(Color(hex: "#F0F2F5"))
                                .cornerRadius(12)
                        }
                        
                        // Sign in button
                        Button(action: {
                            signIn()
                        }) {
                            HStack {
                                Spacer()
                                if isLoading {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                        .scaleEffect(0.8)
                                } else {
                                    Text("Sign In")
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(.white)
                                }
                                Spacer()
                            }
                            .frame(height: 48)
                            .background(Color(hex: "#2699E8"))
                            .cornerRadius(24)
                        }
                        .disabled(isLoading || email.isEmpty || password.isEmpty)
                        
                        // Back to sign up
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Text("Don't have an account? Sign Up")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(Color(hex: "#2699E8"))
                        }
                        .padding(.top, 8)
                    }
                    .padding(.horizontal, 32)
                    
                    Spacer()
                }
            }
        }
        .navigationBarHidden(true)
        .alert("Error", isPresented: $showError) {
            Button("OK") { }
        } message: {
            Text(errorMessage)
        }
    }
    
    // MARK: - Firebase Authentication Methods
    
    private func signIn() {
        guard !email.isEmpty, !password.isEmpty else {
            showErrorMessage("Please fill in all fields")
            return
        }
        
        isLoading = true
        
        Task {
            do {
                try await firebaseManager.signIn(email: email, password: password)
                // Firebase Authentication başarılı olduğunda otomatik olarak MainTabView'a yönlendirilecek
                await MainActor.run {
                    isLoading = false
                }
            } catch {
                await MainActor.run {
                    isLoading = false
                    showErrorMessage(error.localizedDescription)
                }
            }
        }
    }
    
    private func showErrorMessage(_ message: String) {
        errorMessage = message
        showError = true
    }
}



#Preview {
    SignInView()
        .environmentObject(FirebaseManager.shared)
}
