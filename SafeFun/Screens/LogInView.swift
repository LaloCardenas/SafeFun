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

    // Morado de acción (ajústalo a tu paleta cuando la tengas)
    private let actionPurple = Color(hex: 0x6C2CF4)

    var body: some View {
        ZStack {
            BackgroundView()

            ScrollView {
                Spacer()
                VStack(alignment: .leading, spacing: 20) {
                    
                    // Título SafeFun
                    Text("SafeFun")
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .shadow(color: .black.opacity(0.25), radius: 8, x: 0, y: 6)
                        .padding(.top, 24)
                    
                    // Subtítulo
                    Text("Registrarse")
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                        .foregroundStyle(.primary)
                        .shadow(color: .black.opacity(0.25), radius: 8, x: 0, y: 6)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.bottom, 8)

                    // Email
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Ingresa tu correo electrónico")
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
                        Text("Ingresa una contraseña")
                            .font(.subheadline)
                            .foregroundStyle(.primary.opacity(0.9))

                        Group {
                            if isSecure {
                                SecureField("Contraseña", text: $password)
                            } else {
                                TextField("Contraseña", text: $password)
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

                    // Continuar
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
                                Text("Continuar")
                                    .foregroundStyle(.white)
                                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                            }
                        }
                    }
                    .buttonStyle(.plain)
                    .padding(.top, 6)

                    // Link a iniciar sesión
                    HStack(spacing: 6) {
                        Spacer()
                        Text("¿Ya tienes cuenta?")
                            .foregroundStyle(.secondary)
                            .foregroundStyle(.white)
                            .font(.subheadline)
                        Button("Iniciar sesión") {
                            onGoToLogin()
                        }
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(actionPurple)
                        Spacer()
                    }
                    .padding(.top, 4)

                    // Separador "or"
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
                            Image(systemName: "g.circle.fill") // Reemplaza por asset del logo de Google cuando lo tengas
                                .foregroundStyle(.red)
                                .font(.title3)
                            Text("Continuar con Google")
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
                        // Configura tu request si usas Apple ID (name, email, scopes)
                    } onCompletion: { result in
                        // Maneja el resultado
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
                .frame(maxWidth: 600) // para iPad/landscape se ve centrado
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
        // Conecta con tu Auth más adelante
        try? await Task.sleep(nanoseconds: 500_000_000)
    }

    private func onGoogle() {
        // Conecta tu flujo de Google Sign-In aquí
    }

    private func onGoToLogin() {
        // Navega a tu pantalla de Iniciar sesión
    }

    private func onOpenTOS() {
        // Abre Terms of Service
    }

    private func onOpenPrivacy() {
        // Abre Privacy Policy
    }
}

// Utilidad pequeña para Color desde hex (elimina si luego usas tu paleta)
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
