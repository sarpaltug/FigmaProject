//
//  SignInView.swift
//  FigmaProject
//
//  Created by Sarp Ugrasiz on 27.08.2025.
//

import SwiftUI
import AuthenticationServices

struct SignInView: View {
    @EnvironmentObject var firebaseManager: FirebaseManager
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var sessionManager: UserSessionManager
    @EnvironmentObject var databaseManager: DatabaseManager
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isLoading = false
    @State private var errorMessage = ""
    @State private var showError = false
    @State private var rememberMe = true
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
                        
                        // Remember Me checkbox
                        HStack {
                            Button(action: {
                                rememberMe.toggle()
                            }) {
                                HStack(spacing: 8) {
                                    Image(systemName: rememberMe ? "checkmark.square.fill" : "square")
                                        .font(.system(size: 16))
                                        .foregroundColor(rememberMe ? Color(hex: "#2699E8") : .gray)
                                    Text("Remember me")
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(.gray)
                                }
                            }
                            Spacer()
                        }
                        .padding(.top, 8)
                        
                        // Apple Sign In button
                        SignInWithAppleButton(
                            type: .signIn,
                            style: .black
                        ) { result in
                            handleAppleSignIn(result)
                        }
                        .frame(height: 48)
                        .cornerRadius(24)
                        
                        // Divider
                        HStack {
                            Rectangle()
                                .frame(height: 1)
                                .foregroundColor(.gray.opacity(0.3))
                            Text("or")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.gray)
                                .padding(.horizontal, 16)
                            Rectangle()
                                .frame(height: 1)
                                .foregroundColor(.gray.opacity(0.3))
                        }
                        .padding(.vertical, 16)
                        
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
                try await firebaseManager.signIn(email: email, password: password, rememberMe: rememberMe)
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
    
    private func handleAppleSignIn(_ result: Result<ASAuthorization, Error>) {
        isLoading = true
        
        Task {
            do {
                switch result {
                case .success(let authorization):
                    try await firebaseManager.signInWithApple(authorization: authorization)
                    // Firebase Authentication başarılı olduğunda otomatik olarak MainTabView'a yönlendirilecek
                    await MainActor.run {
                        isLoading = false
                    }
                case .failure(let error):
                    await MainActor.run {
                        showErrorMessage("Apple Sign In failed: \(error.localizedDescription)")
                    }
                }
            } catch {
                await MainActor.run {
                    showErrorMessage("Apple Sign In failed: \(error.localizedDescription)")
                }
            }
        }
    }
}



#Preview {
    SignInView()
        .environmentObject(FirebaseManager.shared)
}
