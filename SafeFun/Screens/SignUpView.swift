//
//  SignUpView.swift
//  SafeFun
//
//  Created by Lalo Cardenas on 19/10/25.
//

import SwiftUI
import AuthenticationServices

struct SignUpView: View {
    
    var onContinue: () -> Void = {}   // valor por defecto para no romper previews

    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isSecure: Bool = true
    @State private var isLoading: Bool = false
    @State private var goToLogIn: Bool = false

    // Debe coincidir con LogInView para coherencia visual
    private let actionPurple = Color(hex: 0x6C2CF4)

    var body: some View {
        ZStack {
            BackgroundView()

            ScrollView {
                Spacer()
                VStack(alignment: .leading, spacing: 20) {

                    // Navegación programática hacia LogInView
                    Color.clear
                        .frame(height: 0)
                        .navigationDestination(isPresented: $goToLogIn) {
                            LogInView()
                        }

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
                        Text("Create a password")
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

                    // Create account
                    Button {
                        handleCreateAccount()
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .fill(actionPurple)
                                .frame(height: 52)
                            if isLoading {
                                ProgressView().tint(.white)
                            } else {
                                Text("Create account")
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
                            .font(.subheadline)
                        Button("Log In") {
                            onToLogIn()
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
                    SignInWithAppleButton(.signUp) { request in
                        // Configure request for Sign Up if necessary
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
                .frame(maxWidth: 600)
                .frame(maxWidth: .infinity, alignment: .center)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Actions

    private func handleCreateAccount() {
        guard !isLoading else { return }
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            isLoading = false
            onContinue()
        }
    }

    private func onGoogle() {
        // Conecta tu flujo de Google Sign-In aquí
    }

    private func onToLogIn() {
        goToLogIn = true
    }
}

// Small utility for Color from hex (reutilizada de LogInView)
private extension Color {
    init(hex: UInt, alpha: Double = 1.0) {
        let r = Double((hex >> 16) & 0xFF) / 255.0
        let g = Double((hex >> 8) & 0xFF) / 255.0
        let b = Double(hex & 0xFF) / 255.0
        self = Color(.sRGB, red: r, green: g, blue: b, opacity: alpha)
    }
}

#Preview {
    NavigationStack { SignUpView(onContinue: {}) }
}

