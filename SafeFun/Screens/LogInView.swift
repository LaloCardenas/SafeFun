//
//  LogInView.swift
//  SafeFun
//
//  Created by Lalo Cardenas on 19/10/25.
//

import SwiftUI
import AuthenticationServices

struct LogInView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isSecure: Bool = true
    @State private var isLoading: Bool = false

    // Action purple (adjust to your palette when you have it)
    private let actionPurple = Color(hex: 0x6C2CF4)

    var body: some View {
        ZStack {
            BackgroundView()

            ScrollView {
                Spacer()
                VStack(alignment: .leading, spacing: 20) {
                    
                    // Title SafeFun
                    Text("SafeFun")
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .shadow(color: .black.opacity(0.25), radius: 8, x: 0, y: 6)
                        .padding(.top, 24)
                    
                    // Subtitle
                    Text("Sign Up")
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                        .foregroundStyle(.primary)
                        .shadow(color: .black.opacity(0.25), radius: 8, x: 0, y: 6)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.bottom, 8)

                    // Email
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Enter your email")
                            .font(.subheadline)
                            .foregroundStyle(.primary.opacity(0.9))

                        TextField("email@domain.com", text: $email)
                            .keyboardType(.emailAddress)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled(true)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 12)
                            .background(.white.opacity(0.9))
                            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                    .stroke(.black.opacity(0.08), lineWidth: 1)
                            )
                    }

                    // Password
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Enter a password")
                            .font(.subheadline)
                            .foregroundStyle(.primary.opacity(0.9))

                        Group {
                            if isSecure {
                                SecureField("Password", text: $password)
                            } else {
                                TextField("Password", text: $password)
                            }
                        }
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled(true)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 12)
                        .background(.white.opacity(0.9))
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                        .overlay(alignment: .trailing) {
                            Button {
                                isSecure.toggle()
                            } label: {
                                Image(systemName: isSecure ? "eye.slash" : "eye")
                                    .foregroundStyle(.secondary)
                                    .padding(.trailing, 12)
                            }
                        }
                        .overlay(
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .stroke(.black.opacity(0.08), lineWidth: 1)
                        )
                    }

                    // Continue
                    Button {
                        Task { await onContinue() }
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .fill(actionPurple)
                                .frame(height: 52)
                            if isLoading {
                                ProgressView()
                                    .tint(.white)
                            } else {
                                Text("Continue")
                                    .foregroundStyle(.white)
                                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                            }
                        }
                    }
                    .buttonStyle(.plain)
                    .padding(.top, 6)

                    // Link to log in
                    HStack(spacing: 6) {
                        Spacer()
                        Text("Already have an account?")
                            .foregroundStyle(.secondary)
                            .foregroundStyle(.white)
                            .font(.subheadline)
                        Button("Log In") {
                            onGoToLogin()
                        }
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(actionPurple)
                        Spacer()
                    }
                    .padding(.top, 4)

                    // Separator "or"
                    HStack {
                        Rectangle().fill(.white.opacity(0.6)).frame(height: 1)
                        Text("or")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                            .padding(.horizontal, 8)
                        Rectangle().fill(.white.opacity(0.6)).frame(height: 1)
                    }
                    .padding(.vertical, 6)

                    // Google
                    Button {
                        onGoogle()
                    } label: {
                        HStack(spacing: 12) {
                            Spacer()
                            Image("google_logo")
                                .resizable()
                                .frame(width: 15, height: 15)
                            Text("Continue with Google")
                                .foregroundStyle(.primary)
                                .font(.body.weight(.semibold))
                            Spacer()
                        }
                        .padding(.horizontal, 14)
                        .padding(.vertical, 14)
                        .background(.white.opacity(0.9))
                        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .stroke(.black.opacity(0.08), lineWidth: 1)
                        )
                    }
                    .buttonStyle(.plain)

                    // Apple
                    SignInWithAppleButton(.continue) { request in
                        // Configure your request if you use Apple ID (name, email, scopes)
                    } onCompletion: { result in
                        // Handle result
                    }
                    .signInWithAppleButtonStyle(.black)
                    .frame(height: 52)
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))

                    // Legal
                    VStack(spacing: 4) {
                        Text("By clicking continue, you agree to our")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity, alignment: .center)

                        HStack(spacing: 4) {
                            Button("Terms of Service") { onOpenTOS() }
                                .font(.footnote.weight(.semibold))
                                .foregroundStyle(actionPurple)
                            Text("and")
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                            Button("Privacy Policy") { onOpenPrivacy() }
                                .font(.footnote.weight(.semibold))
                                .foregroundStyle(actionPurple)
                        }
                    }
                    .padding(.top, 6)

                    Spacer(minLength: 24)
                }
                .padding(.horizontal, 20)
                .padding(.top, 24)
                .frame(maxWidth: 600) // centered for iPad/landscape
                .frame(maxWidth: .infinity, alignment: .center)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .navigationBar)
    }

    // MARK: - Actions (stub)
    private func onContinue() async {
        isLoading = true
        defer { isLoading = false }
        // Hook up to your Auth later
        try? await Task.sleep(nanoseconds: 500_000_000)
    }

    private func onGoogle() {
        // Connect your Google Sign-In flow here
    }

    private func onGoToLogin() {
        // Navigate to your Log In screen
    }

    private func onOpenTOS() {
        // Open Terms of Service
    }

    private func onOpenPrivacy() {
        // Open Privacy Policy
    }
}

// Small utility for Color from hex (remove later if you use your palette)
private extension Color {
    init(hex: UInt, alpha: Double = 1.0) {
        let r = Double((hex >> 16) & 0xFF) / 255.0
        let g = Double((hex >> 8) & 0xFF) / 255.0
        let b = Double(hex & 0xFF) / 255.0
        self = Color(.sRGB, red: r, green: g, blue: b, opacity: alpha)
    }
}

#Preview {
    NavigationStack { LogInView() }
}
