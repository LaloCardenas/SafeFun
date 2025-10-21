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
    @State private var goToSignUp: Bool = false

    let onContinue: () -> Void
    init(onContinue: @escaping () -> Void = {}) {
            self.onContinue = onContinue
        }

    // Action purple (adjust to your palette when you have it)
    private let actionPurple = Color(hex: 0x6C2CF4)

    var body: some View {
        ZStack {
            BackgroundView()

            ScrollView {
                Spacer()
                VStack(alignment: .leading, spacing: 20) {

                    // Navegación programática hacia SignUpView
                    Color.clear
                        .frame(height: 0)
                        .navigationDestination(isPresented: $goToSignUp) {
                            SignUpView()
                        }

                    // Title SafeFun
                    Text("SafeFun")
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .shadow(color: .black.opacity(0.25), radius: 8, x: 0, y: 6)
                        .padding(.top, 24)

                    // Subtitle
                    Text("Login")
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
                        Text("Enter your password")
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
                        handleContinueTapped()
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .fill(actionPurple)
                                .frame(height: 52)
                            if isLoading {
                                ProgressView().tint(.white)
                            } else {
                                Text("Continue")
                                    .foregroundStyle(.white)
                                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                            }
                        }
                    }
                    .buttonStyle(.plain)
                    .padding(.top, 6)

                    // Link to sign up
                    HStack(spacing: 6) {
                        Spacer()
                        Text("Don't have an account?")
                            .foregroundStyle(.secondary)
                            .font(.subheadline)
                        Button("Sign Up") {
                            onToSignUp()
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

                    Spacer(minLength: 24)
                }
                .padding(.horizontal, 20)
                .padding(.top, 24)
                .frame(maxWidth: 600) // centered for iPad/landscape
                .frame(maxWidth: .infinity, alignment: .center)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Actions

    private func handleContinueTapped() {
        guard !isLoading else { return }
        // Spiner de carga
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            isLoading = false
            onContinue()
        }
    }

    private func onGoogle() {
        // Connect your Google Sign-In flow here
    }

    private func onToSignUp() {
        goToSignUp = true
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
    NavigationStack { LogInView(onContinue: {}) }
}
