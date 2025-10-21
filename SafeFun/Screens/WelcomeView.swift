//
//  ContentView.swift
//  SafeFun
//
//  Created by Lalo Cardenas on 19/10/25.
//

import SwiftUI

struct WelcomeView: View {
    // Idioma seleccionado (código BCP-47)
    @State private var selectedLanguageCode: String = Locale.current.language.languageCode?.identifier ?? "en"
    @State private var showCompleteProfile = false
    @State private var goToCommunities = false
    // Lista de idiomas disponibles en el picker (sin banderas)
    private let languages: [Language] = [
        .init(code: "en", name: "English"),
        .init(code: "es", name: "Español"),
        .init(code: "fr", name: "Français"),
        .init(code: "de", name: "Deutsch"),
        .init(code: "pt", name: "Português"),
        .init(code: "ja", name: "日本語")
    ]

    // Diccionario local de traducciones solo para esta vista
    // Claves: id lógico del texto. Valores: traducciones por código de idioma.
    private let translations: [String: [String: String]] = [
        "title": [
            "en": "Welcome to SafeFun!",
            "es": "¡Bienvenido a SafeFun!",
            "fr": "Bienvenue sur SafeFun !",
            "de": "Willkommen bei SafeFun!",
            "pt": "Bem-vindo ao SafeFun!",
            "ja": "SafeFunへようこそ！"
        ],
        "subtitle": [
            "en": "Your security network throughout the FIFA World Cup 2026",
            "es": "Tu red de seguridad durante la Copa Mundial de la FIFA 2026",
            "fr": "Votre réseau de sécurité pendant la Coupe du Monde de la FIFA 2026",
            "de": "Ihr Sicherheitsnetz während der FIFA-Weltmeisterschaft 2026",
            "pt": "Sua rede de segurança durante a Copa do Mundo da FIFA 2026",
            "ja": "FIFAワールドカップ2026の期間中、あなたのセキュリティネットワーク"
        ],
        "languageLabel": [
            "en": "Language",
            "es": "Idioma",
            "fr": "Langue",
            "de": "Sprache",
            "pt": "Idioma",
            "ja": "言語"
        ],
        "signUp": [
            "en": "Sign Up",
            "es": "Crear cuenta",
            "fr": "Créer un compte",
            "de": "Registrieren",
            "pt": "Criar conta",
            "ja": "新規登録"
        ],
        "logIn": [
            "en": "Log In",
            "es": "Iniciar sesión",
            "fr": "Se connecter",
            "de": "Anmelden",
            "pt": "Entrar",
            "ja": "ログイン"
        ]
    ]

    var body: some View {
        NavigationStack {
            ZStack {
                BackgroundView() // reusable background
                VStack {
                    Spacer()
                    // Section 1: Title and subtitle
                    VStack(spacing: 16) {
                        Text(t("title"))
                            .font(.system(size: 64, weight: .bold, design: .rounded))
                            .foregroundStyle(.white)
                            .shadow(color: .black.opacity(0.25), radius: 8, x: 0, y: 6)
                            .multilineTextAlignment(.center)

                        Text(t("subtitle"))
                            .font(.system(size: 22, weight: .semibold, design: .rounded))
                            .foregroundStyle(.white.opacity(0.9))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    .frame(maxWidth: 700)
                    .padding(.top, 24)
                    
                    Spacer(minLength: 24)

                    // Section 2: Language picker (sin banderas)
                    VStack(spacing: 12) {
                        HStack(spacing: 12) {
                            // Etiqueta “Idioma”
                            VStack(alignment: .leading, spacing: 2) {
                                Text(t("languageLabel"))
                                    .font(.caption)
                                    .foregroundStyle(.white.opacity(0.8))
                                // Nombre del idioma seleccionado
                                Text(nameForSelectedLanguage)
                                    .font(.system(size: 24))
                                    .foregroundStyle(.white)
                            }

                            Spacer()

                            // Picker simple con nombres de idioma
                            Picker(selection: $selectedLanguageCode) {
                                ForEach(languages, id: \.code) { lang in
                                    Text(lang.name)
                                        .tag(lang.code)
                                }
                            } label: {
                                Text(nameForSelectedLanguage)
                            }
                            .pickerStyle(.menu)
                            .tint(.white)
                            .foregroundStyle(.white)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(.white.opacity(0.12))
                        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .stroke(.white.opacity(0.18), lineWidth: 1)
                        )
                        .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 6)
                    }
                    .frame(maxWidth: 700)
                    
                    Spacer(minLength: 36)
                    
                    // Section 3: Buttons
                    VStack(spacing: 14) {
                        // Primary button: Sign Up
                        NavigationLink {
                            SignUpView {
                                showCompleteProfile = true
                            }
                        } label: {
                            Text(t("signUp"))
                                .font(.system(size: 20, weight: .bold, design: .rounded))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(Color.wcGold)
                                .foregroundStyle(Color.black)
                                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                        }
                        .shadow(color: .black.opacity(0.25), radius: 10, x: 0, y: 8)
                        
                        // Secondary button: Log In
                        NavigationLink {
                            LogInView {
                                showCompleteProfile = true
                            }
                        } label: {
                            Text(t("logIn"))
                                .font(.system(size: 20, weight: .semibold, design: .rounded))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .foregroundStyle(.white)
                                .background(Color.wcPurple)
                                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                        }
                        .shadow(color: .black.opacity(0.25), radius: 10, x: 0, y: 8)
                    }
                    .frame(maxWidth: 700)
                    
                    Spacer(minLength: 24)
                }
                .padding(.horizontal)
            }
            .toolbar(.hidden, for: .navigationBar)
            
            NavigationLink(
                destination: AppTabView(), isActive: $goToCommunities
            ){ EmptyView()}
                .hidden()
        }
        .sheet(isPresented: $showCompleteProfile) {
            CompleteProfileView(onFinish: {
                showCompleteProfile = false
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    goToCommunities = true
                }
            }).interactiveDismissDisabled(true)
        }
    }

    // MARK: - Derived helpers

    private func t(_ key: String) -> String {
        // Obtiene traducción según idioma seleccionado; fallback a inglés o clave
        translations[key]?[selectedLanguageCode]
        ?? translations[key]?["en"]
        ?? key
    }

    private var nameForSelectedLanguage: String {
        languages.first(where: { $0.code == selectedLanguageCode })?.name
        ?? "English"
    }
}

// Modelo simple de idioma (sin bandera)
private struct Language: Hashable {
    let code: String   // "en", "es", "fr", ...
    let name: String   // "English", "Español", ...
}

#Preview {
    WelcomeView()
}
