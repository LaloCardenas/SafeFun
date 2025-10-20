//
//  ContentView.swift
//  SafeFun
//
//  Created by Lalo Cardenas on 19/10/25.
//

import SwiftUI

struct WelcomeView: View {
    @State private var selectedLanguage: String = "English"
    private let languages: [String] = ["English", "Español"]

    var body: some View {
        NavigationStack {
            ZStack {
                BackgroundView() // fondo reutilizable
                // Contenedor principal
                VStack {
                    Spacer()
                    // Sección 1: Título y subtítulo
                    VStack(spacing: 16) {
                        Text("Welcome to SafeFun!")
                            .font(.system(size: 64, weight: .bold, design: .rounded))
                            .foregroundStyle(.white)
                            .shadow(color: .black.opacity(0.25), radius: 8, x: 0, y: 6)
                            .multilineTextAlignment(.center)

                        Text("Your security network throughout the FIFA World Cup 2026")
                            .font(.system(size: 22, weight: .semibold, design: .rounded))
                            .foregroundStyle(.white.opacity(0.9))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    .frame(maxWidth: 700)
                    .padding(.top, 24)

                    // Espacio entre sección 1 y 2
                    Spacer(minLength: 24)

                    // Sección 2: Picker de idioma
                    VStack(spacing: 12) {
                        HStack(spacing: 12) {
                            Image(systemName: "globe")
                                .foregroundStyle(.white.opacity(0.9))

                            Picker("Language", selection: $selectedLanguage) {
                                ForEach(languages, id: \.self) { lang in
                                    Text(lang).tag(lang)
                                }
                            }
                            .pickerStyle(.menu)
                            .tint(.white)
                            .foregroundStyle(.white)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .frame(maxWidth: .infinity)
                        .background(.white.opacity(0.12))
                        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .stroke(.white.opacity(0.18), lineWidth: 1)
                        )
                        .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 6)
                    }
                    .frame(maxWidth: 700)

                    // Espacio entre sección 2 y 3 (un poco mayor para separar controles de botones)
                    Spacer(minLength: 36)

                    // Sección 3: Botones
                    VStack(spacing: 14) {
                        // Botón principal: Sign Up (navega a SignUpView)
                        NavigationLink {
                            SignUpView()
                        } label: {
                            Text("Sign Up")
                                .font(.system(size: 20, weight: .bold, design: .rounded))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(Color.wcGold) // contraste alto
                                .foregroundStyle(Color.black) // mejor legibilidad sobre dorado
                                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                        }
                        .shadow(color: .black.opacity(0.25), radius: 10, x: 0, y: 8)

                        // Botón secundario: Log In (navega a LogInView) con mayor contraste
                        NavigationLink {
                            LogInView()
                        } label: {
                            Text("Log In")
                                .font(.system(size: 20, weight: .semibold, design: .rounded))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .foregroundStyle(.white)
                                .background(Color.wcPurple) // color sólido y contrastante
                                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                        }
                        .shadow(color: .black.opacity(0.25), radius: 10, x: 0, y: 8)
                    }
                    .frame(maxWidth: 700)

                    // Espacio inferior para respirar en pantallas altas
                    Spacer(minLength: 24)
                }
                .padding(.horizontal)
            }
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    WelcomeView()
}
