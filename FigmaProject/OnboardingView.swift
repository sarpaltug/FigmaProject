//
//  OnboardingView.swift
//  FigmaProject
//
//  Created by Sarp Ugrasiz on 14.08.2025.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import AuthenticationServices
import CryptoKit
import UIKit

// MARK: - Notification Extensions
extension Notification.Name {
    static let appleSignInSuccess = Notification.Name("appleSignInSuccess")
    static let appleSignInError = Notification.Name("appleSignInError")
    static let googleSignInSuccess = Notification.Name("googleSignInSuccess")
    static let googleSignInError = Notification.Name("googleSignInError")
}

// MARK: - Color Extension
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
                    
                    // Apple Sign In Button - Disabled (Requires Paid Apple Developer Program)
                    /*
                    Button(action: {
                        // Callback'i ayarla
                        SignInWithApple.instance.onAuthenticationComplete = { name, email, provider, credential in
                            connectToFirebase(name: name, email: email, provider: provider, credential: credential)
                        }
                        // Apple Sign In'i başlat
                        SignInWithApple.instance.startSignInWithAppleFlow()
                    }) {
                        HStack {
                            Image(systemName: "applelogo")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.white)
                            Text("Continue with Apple")
                                .font(.system(size: 18, weight: .bold, design: .default))
                                .foregroundColor(.white)
                        }
                        .frame(height: 56)
                        .frame(maxWidth: .infinity)
                        .background(Color.black)
                        .cornerRadius(28)
                        .padding(.horizontal, 20)
                    }
                    .padding(.bottom, 16)
                    */
                    
                    // Google Sign In Button - Temporarily Disabled
                    /*
                    Button(action: {
                        // Google Sign In functionality will be added later
                    }) {
                        HStack {
                            Image(systemName: "globe")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.black)
                            Text("Continue with Google")
                                .font(.system(size: 18, weight: .bold, design: .default))
                                .foregroundColor(.black)
                        }
                        .frame(height: 56)
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 28)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                        .cornerRadius(28)
                        .padding(.horizontal, 20)
                    }
                    .padding(.bottom, 16)
                    */
                    
                    // Get started button (Email/Password)
                    Button(action: {
                        shouldNavigate = true
                    }) {
                        HStack {
                            Spacer()
                            Text("Get started with Email")
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
                // Apple Sign In notification listeners - Disabled
                /*
                NotificationCenter.default.addObserver(
                    forName: .appleSignInSuccess,
                    object: nil,
                    queue: .main
                ) { _ in
                    // Apple Sign In başarılı, ana ekrana git
                    shouldNavigate = true
                }
                
                NotificationCenter.default.addObserver(
                    forName: .appleSignInError,
                    object: nil,
                    queue: .main
                ) { notification in
                    if let error = notification.object as? Error {
                        print("Apple Sign In Error: \(error.localizedDescription)")
                    }
                }
                */
                
                // Google Sign In notification listeners - Temporarily Disabled
                /*
                NotificationCenter.default.addObserver(
                    forName: .googleSignInSuccess,
                    object: nil,
                    queue: .main
                ) { _ in
                    // Google Sign In başarılı, ana ekrana git
                    shouldNavigate = true
                }
                
                NotificationCenter.default.addObserver(
                    forName: .googleSignInError,
                    object: nil,
                    queue: .main
                ) { notification in
                    if let error = notification.object as? Error {
                        print("Google Sign In Error: \(error.localizedDescription)")
                    }
                }
                */
            }
            .onDisappear {
                // Notification observers'ları temizle - Disabled
                /*
                NotificationCenter.default.removeObserver(self, name: .appleSignInSuccess, object: nil)
                NotificationCenter.default.removeObserver(self, name: .appleSignInError, object: nil)
                NotificationCenter.default.removeObserver(self, name: .googleSignInSuccess, object: nil)
                NotificationCenter.default.removeObserver(self, name: .googleSignInError, object: nil)
                */
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
    
    // MARK: - Firebase Authentication Functions
    
    func connectToFirebase(name: String, email: String, provider: String, credential: AuthCredential) {
        Task {
            do {
                // Firebase'e giriş yap
                let result = try await Auth.auth().signIn(with: credential)
                let user = result.user
                
                print("✅ Firebase Authentication Success!")
                print("👤 User ID: \(user.uid)")
                print("📧 Email: \(email)")
                print("🔐 Provider: \(provider)")
                
                // Kullanıcı profilini Firestore'a kaydet
                await saveUserToFirestore(
                    uid: user.uid,
                    name: name,
                    email: email,
                    provider: provider
                )
                
                // Ana ekrana geçiş yap
                await MainActor.run {
                    shouldNavigate = true
                }
                
            } catch {
                print("❌ Firebase Authentication Error: \(error.localizedDescription)")
                await MainActor.run {
                    // Hata mesajı göster (opsiyonel)
                }
            }
        }
    }
    
    func saveUserToFirestore(uid: String, name: String, email: String, provider: String) async {
        do {
            // Firestore'a kullanıcı bilgilerini kaydet
            try await firebaseManager.saveUserToFirestore(
                user: Auth.auth().currentUser!,
                name: name
            )
            
            // Session manager'ı güncelle
            let userProfile = UserProfileModel(data: [
                "uid": uid,
                "email": email,
                "displayName": name,
                "selectedLanguage": "",
                "totalXP": 0,
                "createdAt": Timestamp(date: Date()),
                "lastLoginAt": Timestamp(date: Date())
            ])
            
            sessionManager.saveUserSession(
                userProfile: userProfile,
                method: provider == "apple.com" ? .apple : .email,
                rememberUser: true
            )
            
            print("✅ User saved to Firestore and session updated")
            
        } catch {
            print("❌ Firestore save error: \(error.localizedDescription)")
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



// MARK: - Sign In Providers - Temporarily Disabled

// SignInWithApple class temporarily disabled - requires paid Apple Developer Program
/*
class SignInWithApple: NSObject, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    static let instance = SignInWithApple()
    
    // Callback closure for OnboardingView integration
    var onAuthenticationComplete: ((String, String, String, AuthCredential) -> Void)?

    // Unhashed nonce.
    fileprivate var currentNonce: String?

    func startSignInWithAppleFlow() {
      let nonce = randomNonceString()
      currentNonce = nonce
      let appleIDProvider = ASAuthorizationAppleIDProvider()
      let request = appleIDProvider.createRequest()
      request.requestedScopes = [.fullName, .email]
      request.nonce = sha256(nonce)

      let authorizationController = ASAuthorizationController(authorizationRequests: [request])
      authorizationController.delegate = self
      authorizationController.presentationContextProvider = self
      authorizationController.performRequests()
    }
    
    private func randomNonceString(length: Int = 32) -> String {
      precondition(length > 0)
      var randomBytes = [UInt8](repeating: 0, count: length)
      let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
      if errorCode != errSecSuccess {
        fatalError(
          "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
        )
      }
      let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
      let nonce = randomBytes.map { byte in
        // Pick a random character from the set, wrapping around if needed.
        charset[Int(byte) % charset.count]
      }
      return String(nonce)
    }
    
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
          guard let nonce = currentNonce else {
            fatalError("Invalid state: A login callback was received, but no login request was sent.")
          }
          guard let appleIDToken = appleIDCredential.identityToken else {
            print("Unable to fetch identity token")
            return
          }
          guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
            print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
            return
          }
            
            
            let email = appleIDCredential.email ?? "Unknown Email"
            
            let name: String
            if let fullName = appleIDCredential.fullName {
                let formatter = PersonNameComponentsFormatter()
                name = formatter.string(from: fullName)
            } else {
                name = "Apple User"
            }
          // Initialize a Firebase credential, including the user's full name.
          let credential = OAuthProvider.appleCredential(withIDToken: idTokenString,
                                                            rawNonce: nonce,
                                                            fullName: appleIDCredential.fullName)
            
            // OnboardingView callback'ini çağır
            if let callback = onAuthenticationComplete {
                callback(name, email, "apple.com", credential)
            } else {
                // Fallback: NotificationCenter kullan
                Task {
                    do {
                        let result = try await Auth.auth().signIn(with: credential)
                        print("✅ Apple Sign In successful: \(result.user.uid)")
                        
                        await MainActor.run {
                            NotificationCenter.default.post(name: .appleSignInSuccess, object: nil)
                        }
                    } catch {
                        print("❌ Firebase sign in error: \(error.localizedDescription)")
                        await MainActor.run {
                            NotificationCenter.default.post(name: .appleSignInError, object: error)
                        }
                    }
                }
            }
        }
      }

      func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
        print("Sign in with Apple errored: \(error)")
      }
    
    // MARK: - ASAuthorizationControllerPresentationContextProviding
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            fatalError("No window available")
        }
        return window
    }
}
*/

// SignInWithGoogle class temporarily disabled - will be added when Google Sign In SDK is properly configured
/*
class SignInWithGoogle: NSObject {
    static let instance = SignInWithGoogle()
    var onAuthenticationComplete: ((String, String, String, AuthCredential) -> Void)?
    
    private override init() {
        super.init()
    }
    
    func startSignInWithGoogleFlow() {
        print("Google Sign In temporarily disabled")
    }
}
*/

#Preview {
    OnboardingView()
}
