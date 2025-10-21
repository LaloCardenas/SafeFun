//
//  ProfileView.swift
//  SafeFun
//
//  Created by Lalo Cardenas on 20/10/25.
//  Modified by Hector Larios at 20-10-25 11:17
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        ZStack {
            BackgroundView()

            // Contenido
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    ProfileHeaderCard()

                    QuickActionsRow()

                    ProfileSection(
                        title: "Cuenta",
                        rows: [
                            .init(icon: "person.text.rectangle", title: "Editar perfil"),
                            .init(icon: "checkmark.seal.fill", title: "Verificación"),
                            .init(icon: "phone.fill", title: "Contacto de emergencia")
                        ]
                    )

                    ProfileSection(
                        title: "Preferencias",
                        rows: [
                            .init(icon: "bell.badge.fill", title: "Notificaciones"),
                            .init(icon: "hand.raised.fill", title: "Privacidad"),
                            .init(icon: "figure.walk.motion", title: "Comunidades y grupos")
                        ]
                    )

                    ProfileSection(
                        title: "Seguridad",
                        rows: [
                            .init(icon: "faceid", title: "Face ID"),
                            .init(icon: "lock.shield.fill", title: "Contraseña y acceso"),
                            .init(icon: "list.bullet.rectangle.portrait.fill", title: "Términos y privacidad")
                        ]
                    )

                    SignOutButton()
                        .padding(.top, 4)
                }
                .padding(.vertical, 24)
                .padding(.bottom, 60)
            }
            .padding(.horizontal)
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct ProfileHeaderCard: View {
    @State private var pillsEqualHeight: CGFloat = 0
    var body: some View {
        VStack(spacing: 16) {
            // Avatar con aro degradado (match con paleta)
            ZStack {
                Circle()
                    .strokeBorder(
                        AngularGradient(
                            gradient: Gradient(colors: [.wcGold, .wcPurple, .wcCyan, .wcBlue]),
                            center: .center
                        ),
                        lineWidth: 4
                    )
                    .frame(width: 118, height: 118)

                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 110, height: 110)
                    .foregroundStyle(.ultraThinMaterial)
                    .overlay(
                        Circle()
                            .fill(.ultraThinMaterial)
                    )
            }

            VStack(spacing: 4) {
                HStack(spacing: 8) {
                    Text("Héctor Larios")
                        .font(.title2.bold())
                        .foregroundStyle(.primary)

                    Image(systemName: "checkmark.seal.fill")
                        .foregroundStyle(.wcGold)
                        .font(.title3)
                        .accessibilityLabel("Cuenta verificada")
                }

                Text("@heclarios")
                    .font(.callout)
                    .foregroundStyle(.secondary)
            }

            // Stats / badges
            HStack(spacing: 12) {
                StatPill(icon: "person.3.fill",       value: "8",  label: "Grupos",   equalHeight: pillsEqualHeight)
                StatPill(icon: "mappin.and.ellipse",  value: "3",  label: "Ciudades", equalHeight: pillsEqualHeight)
                StatPill(icon: "bell.fill",           value: "12", label: "Alertas",  equalHeight: pillsEqualHeight)
            }
            .onPreferenceChange(PillMaxHeightKey.self) { maxH in
                pillsEqualHeight = maxH
            }
            .frame(maxWidth: .infinity)
            .fixedSize(horizontal: false, vertical: true)
        }
        .padding(30)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .strokeBorder(.white.opacity(0.15), lineWidth: 1)
        )
        .shadow(radius: 20, y: 8)
        .accessibilityElement(children: .contain)
    }
}

private struct QuickActionsRow: View {
    var body: some View {
        HStack(spacing: 12) {
            QuickActionButton(icon: "pencil.line", title: "Editar")
            QuickActionButton(icon: "phone.fill", title: "Emergencia")
            QuickActionButton(icon: "hand.raised.fill", title: "Privacidad")
            QuickActionButton(icon: "gearshape.fill", title: "Ajustes")
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(14)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .strokeBorder(.white.opacity(0.12), lineWidth: 1)
        )
        .shadow(radius: 16, y: 6)
    }
}

private struct ProfileSection: View {
    struct Row: Identifiable {
        let id = UUID()
        let icon: String
        let title: String
    }

    let title: String
    let rows: [Row]

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.headline)
                .foregroundStyle(.secondary)
                .padding(.horizontal, 6)

            VStack(spacing: 0) {
                ForEach(Array(rows.enumerated()), id: \.element.id) { index, row in
                    Button {
                        // TODO: navegar a la pantalla correspondiente
                    } label: {
                        HStack(spacing: 14) {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(
                                    LinearGradient(
                                        colors: [.wcPurple.opacity(0.25), .wcCyan.opacity(0.25)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 38, height: 38)
                                .overlay(
                                    Image(systemName: row.icon)
                                        .font(.headline)
                                        .foregroundStyle(.white.opacity(0.9))
                                )

                            Text(row.title)
                                .foregroundStyle(.primary)
                                .font(.body)

                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        .contentShape(Rectangle())
                        .padding(.vertical, 12)
                        .padding(.horizontal, 14)
                    }
                    .buttonStyle(.plain)

                    if index < rows.count - 1 {
                        Divider().opacity(0.2)
                    }
                }
            }
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 18)
                    .strokeBorder(.white.opacity(0.1), lineWidth: 1)
            )
            .shadow(radius: 12, y: 5)
        }
    }
}

private struct SignOutButton: View {
    var body: some View {
        Button {
            // TODO: acción de cerrar sesión
        } label: {
            HStack(spacing: 10) {
                Image(systemName: "rectangle.portrait.and.arrow.right.fill")
                Text("Cerrar sesión").bold()
            }
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
        .tint(.wcRed)
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .shadow(radius: 10, y: 5)
    }
}

private struct QuickActionButton: View {
    let icon: String
    let title: String

    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.title3)
                .padding(10)
                .background(
                    LinearGradient(
                        colors: [.wcGold.opacity(0.35), .wcPurple.opacity(0.35)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .strokeBorder(.white.opacity(0.18), lineWidth: 1)
                )
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

private struct PillMaxHeightKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
}

private struct StatPill: View {
    let icon: String
    let value: String
    let label: String
    let equalHeight: CGFloat? // altura sincronizada desde el padre

    var body: some View {
        let base = ViewThatFits(in: .horizontal) {

            // 1) Una sola fila (preferido)
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.callout) // mismo tamaño que el texto
                    .accessibilityHidden(true)

                Text(value)
                    .font(.callout).fontWeight(.semibold)
                    .monospacedDigit()
                    .lineLimit(1)

                Text(label)
                    .font(.callout)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.9)
                    .allowsTightening(true)
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .background(.ultraThinMaterial, in: Capsule())
            .overlay(Capsule().stroke(.white.opacity(0.2), lineWidth: 1))

            // 2) Dos filas (fallback)
            VStack(spacing: 4) {
                HStack(spacing: 6) {
                    Image(systemName: icon)
                        .font(.callout)
                        .accessibilityHidden(true)
                    Text(value)
                        .font(.callout).fontWeight(.semibold)
                        .monospacedDigit()
                        .lineLimit(1)
                }
                Text(label)
                    .font(.callout) // mismo tamaño que horizontal
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .background(.ultraThinMaterial, in: Capsule())
            .overlay(Capsule().stroke(.white.opacity(0.2), lineWidth: 1))
        }

        base
            // Medimos la altura intrínseca resultante
            .background(
                GeometryReader { proxy in
                    Color.clear
                        .preference(key: PillMaxHeightKey.self, value: proxy.size.height)
                }
            )
            // Si el padre nos pasa una altura común, la aplicamos.
            .frame(height: equalHeight)
            .contentShape(Rectangle())
            .accessibilityElement(children: .combine)
            .accessibilityLabel("\(label): \(value)")
    }
}
#Preview {
    NavigationStack {
        ProfileView()
            .preferredColorScheme(.dark)
    }
}
