//
//  ContentView.swift
//  SafeFun
//
//  Created by Lalo Cardenas on 19/10/25.
//

import SwiftUI

struct WelcomeView: View {
    @State private var selectedCountry: String = "United States"

    // Country list storing the display name and its flag emoji
    private let countries: [(name: String, flag: String)] = [
        ("United States", "🇺🇸"),
        ("Mexico", "🇲🇽"),
        ("Canada", "🇨🇦"),
        ("Argentina", "🇦🇷"),
        ("Brazil", "🇧🇷"),
        ("United Kingdom", "🇬🇧"),
        ("Spain", "🇪🇸"),
        ("France", "🇫🇷"),
        ("Germany", "🇩🇪"),
        ("Japan", "🇯🇵")
    ]

    var body: some View {
        NavigationStack {
            ZStack {
                BackgroundView() // reusable background
                // Main container
                VStack {
                    Spacer()
                    // Section 1: Title and subtitle
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

                    // Space between section 1 and 2
                    Spacer(minLength: 24)

                    // Section 2: Country picker
                    VStack(spacing: 12) {
                        HStack(spacing: 12) {
                            // Picker con label solo de bandera (Opción B)
                            Picker(selection: $selectedCountry) {
                                ForEach(countries, id: \.name) { item in
                                    HStack {
                                        Text(item.flag)
                                    }
                                    .tag(item.name)
                                }
                            } label: {
                                Text(flagForSelectedCountry)
                            }
                            .pickerStyle(.menu)
                            .tint(.white)
                            .foregroundStyle(.white)

                            // Nombre del país seleccionado siempre visible a la derecha
                            Text(selectedCountry)
                                .font(.system(size: 24))
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

                    // Space between section 2 and 3
                    Spacer(minLength: 36)

                    // Section 3: Buttons
                    VStack(spacing: 14) {
                        // Primary button: Sign Up
                        NavigationLink {
                            SignUpView()
                        } label: {
                            Text("Sign Up")
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
                            LogInView()
                        } label: {
                            Text("Log In")
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

                    // Bottom spacing
                    Spacer(minLength: 24)
                }
                .padding(.horizontal)
            }
            .navigationBarHidden(true)
        }
    }

    // MARK: - Derived
    private var flagForSelectedCountry: String {
        countries.first(where: { $0.name == selectedCountry })?.flag ?? "🏳️"
    }
}

#Preview {
    WelcomeView()
}
