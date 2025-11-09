//
//  ProfileView.swift
//  SafeFun
//
//  Created by Lalo Cardenas on 20/10/25.
//

import SwiftUI
import CoreLocation
import UIKit

struct ProfileView: View {
    
    
    @State private var user = User(
        firstName: "Héctor",
        lastName: "Larios",
        username: "heclarios",
        team: "México",
        emergencyContacts: [
            EmergencyContact(name: "Mamá", phone: "55654321"),
            EmergencyContact(name: "Papá", phone: "55123456")
        ]
    )
    
    @State private var isShowingEditSheet = false
    @State private var showVerificationModal = false
    
    @State private var showNotificationsScreen = false
    @State private var showPrivacyScreen = false
    @State private var showCommunitiesScreen = false
    @State private var showTermsScreen = false
    
    @State private var showSimulatorAlert = false
    @State private var showWelcomeView = false

    
    var body: some View {
        ZStack {
            BackgroundView()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    
                    ProfileHeaderCard(user: user)
                    
                    // MARK: - Account
                    ProfileSection(
                        title: "Cuenta",
                        rows: [
                            .init(icon: "person.text.rectangle", title: "Editar perfil"),
                            .init(icon: "checkmark.seal.fill", title: "Verificación"),
                            .init(icon: "mappin.and.ellipse", title: "Selección: \(user.team)")
                        ],
                        onRowTapped: { rowTitle in
                            switch rowTitle {
                            case "Editar perfil":
                                isShowingEditSheet = true
                            case "Verificación":
                                withAnimation(.spring()) {
                                    showVerificationModal = true
                                }
                            default:
                                if rowTitle.starts(with: "Selección:") {
                                    isShowingEditSheet = true
                                }
                            }
                        }
                    )
                    
                    if !user.emergencyContacts.isEmpty {
                        ProfileSection(
                            title: "Contactos de emergencia",
                            rows: user.emergencyContacts.map {
                                .init(icon: "phone.fill", title: "\($0.name): \($0.phone)")
                            },
                            onRowTapped: { tappedTitle in
                                if let phone = tappedTitle.split(separator: ":").last?
                                    .trimmingCharacters(in: .whitespacesAndNewlines) {
                                    makePhoneCall(to: phone)
                                }
                            }
                        )
                    }




                    
                    // MARK: - Preferences
                    ProfileSection(
                        title: "Preferencias",
                        rows: [
                            .init(icon: "bell.badge.fill", title: "Notificaciones"),
                            .init(icon: "hand.raised.fill", title: "Privacidad"),
                        ],
                        onRowTapped: { rowTitle in
                            switch rowTitle {
                            case "Notificaciones":
                                showNotificationsScreen = true
                            case "Privacidad":
                                showPrivacyScreen = true
                            default:
                                break
                            }
                        }
                    )
                    
                    // MARK: - Security
                    ProfileSection(
                        title: "Seguridad",
                        rows: [
                            .init(icon: "list.bullet.rectangle.portrait.fill", title: "Términos y condiciones")
                        ],
                        onRowTapped: { rowTitle in
                            if rowTitle == "Términos y condiciones" {
                                showTermsScreen = true
                            }
                        }
                    )
                    
                    SignOutButton{
                        showWelcomeView = true
                    }
                        .padding(.top, 4)
                }
                .padding(.vertical, 24)
                .padding(.bottom, 60)
            }
            .padding(.horizontal)
            
            if showVerificationModal {
                Color.black.opacity(0.35)
                    .ignoresSafeArea()
                    .transition(.opacity)
                    .onTapGesture {
                        withAnimation(.spring()) {
                            showVerificationModal = false
                        }
                    }
                
                VStack(spacing: 16) {
                    VerificationAlertView()
                    
                    HStack(spacing: 12) {
                        Button {
                            withAnimation(.spring()) {
                                showVerificationModal = false
                            }
                        } label: {
                            Text("Cerrar")
                                .bold()
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(.ultraThinMaterial)
                                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                        }
                        
                    }
                    .padding(.horizontal)
                }
                .padding(20)
                .frame(maxWidth: 520)
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
                .overlay(RoundedRectangle(cornerRadius: 18).stroke(.white.opacity(0.08), lineWidth: 1))
                .shadow(radius: 20, y: 8)
                .transition(.scale)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $isShowingEditSheet) {
            EditProfileView(user: $user)
        }
        .sheet(isPresented: $showNotificationsScreen) {
            NotificationsSettingsView()
        }
        .sheet(isPresented: $showPrivacyScreen) {
            PrivacyView()
        }
        .sheet(isPresented: $showTermsScreen) {
            TermsView()
        }
        
        .fullScreenCover(isPresented: $showWelcomeView) {
            NavigationStack {
                WelcomeView()
                    .navigationBarBackButtonHidden(true)
            }
        }
        
    }
}

private struct ProfileHeaderCard: View {
    var user: User
    @State private var pillsEqualHeight: CGFloat = 0
    
    var body: some View {
        VStack(spacing: 16) {
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
                    .resizable().scaledToFit().frame(width: 110, height: 110)
                    .foregroundStyle(.ultraThinMaterial)
                    .overlay(Circle().fill(.ultraThinMaterial))
            }

            VStack(spacing: 4) {
                HStack(spacing: 8) {
                    Text(user.fullName)
                        .font(.title2.bold())
                        .foregroundStyle(.primary)

                    Image(systemName: "checkmark.seal.fill")
                        .foregroundStyle(.wcGold)
                        .font(.title3)
                        .accessibilityLabel("Verified account")
                }
                Text("@\(user.username)")
                    .font(.callout)
                    .foregroundStyle(.secondary)
            }

            GeometryReader { proxy in
                HStack(spacing: 12) {
                    StatPill(icon: "flag.fill", value: user.team, label: "Selección", equalHeight: pillsEqualHeight)
                        .frame(width: (proxy.size.width - 32) / 2)
                    StatPill(icon: "bell.fill", value: "2", label: "Alertas", equalHeight: pillsEqualHeight)
                        .frame(width: (proxy.size.width - 40) / 2)
                }
                .onPreferenceChange(PillMaxHeightKey.self) { maxH in
                    pillsEqualHeight = maxH
                }
                .frame(maxWidth: .infinity)
            }
            .frame(height: pillsEqualHeight)
            .padding(.horizontal)
        }
        .padding(30)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 24).strokeBorder(.white.opacity(0.15), lineWidth: 1))
        .shadow(radius: 20, y: 8)
        .accessibilityElement(children: .contain)
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
    var onRowTapped: (String) -> Void = { _ in }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.headline)
                .foregroundStyle(.secondary)
                .padding(.horizontal, 6)

            VStack(spacing: 0) {
                ForEach(Array(rows.enumerated()), id: \.element.id) { index, row in
                    Button {
                        onRowTapped(row.title)
                    } label: {
                        HStack(spacing: 14) {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(LinearGradient(colors: [.wcPurple.opacity(0.25), .wcCyan.opacity(0.25)], startPoint: .topLeading, endPoint: .bottomTrailing))
                                .frame(width: 38, height: 38)
                                .overlay(Image(systemName: row.icon).font(.headline).foregroundStyle(.white.opacity(0.9)))

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
            .overlay(RoundedRectangle(cornerRadius: 18).strokeBorder(.white.opacity(0.1), lineWidth: 1))
            .shadow(radius: 12, y: 5)
        }
    }
}

private struct SignOutButton: View {
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 10) {
                Image(systemName: "rectangle.portrait.and.arrow.right.fill")
                Text("Sign out").bold()
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
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.title3)
                    .padding(10)
                    .background(LinearGradient(colors: [.wcGold.opacity(0.35), .wcPurple.opacity(0.35)], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(.white.opacity(0.18), lineWidth: 1))
                Text(title)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.plain)
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
    let equalHeight: CGFloat?

    var body: some View {
        VStack(spacing: 4) {
            // TOP valor
            Text(value)
                .font(.title3)
                .fontWeight(.semibold)
                .monospacedDigit()
                .lineLimit(1)
                .minimumScaleFactor(0.9)
                .multilineTextAlignment(.center)

            //  BOTTOM texto
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.callout)
                    .accessibilityHidden(true)
                Text(label)
                    .font(.callout)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.9)
                    .allowsTightening(true)
            }
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(.ultraThinMaterial, in: Capsule())
        .overlay(Capsule().stroke(.white.opacity(0.2), lineWidth: 1))
        .background(
            GeometryReader { proxy in
                Color.clear.preference(key: PillMaxHeightKey.self, value: proxy.size.height)
            }
        )
        .contentShape(Rectangle())
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(label): \(value)")
    }
}


#Preview {
    NavigationStack {
        ProfileView()
            .preferredColorScheme(.light)
    }
}

private struct VerificationAlertView: View {
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "checkmark.seal.fill")
                .font(.title3)
                .foregroundStyle(.green)

            VStack(alignment: .leading, spacing: 2) {
                Text("Cuenta Verificada")
                    .font(.headline)
                    .foregroundStyle(.primary)
                Text("Ahora puedes acceder a todas las funcionalidades de las comunidades.")
                    .font(.callout)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(16)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 18).stroke(.white.opacity(0.1), lineWidth: 1))
        .shadow(radius: 12, y: 5)
        .padding(.horizontal)
    }
}

struct NotificationsSettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var messages = true
    @State private var invitations = true
    @State private var newMembers = true
    @State private var meetingUpdates = true

    @State private var liveResults = true
    @State private var localNews = true
    @State private var selectedCity = "Ciudad de México"
    private let cities = ["Toronto", "Vancouver", "Ciudad de México", "Guadalajara", "Monterrey", "Atlanta", "Boston", "Dallas", "Houston", "Kansas City", "Los Angeles", "Miami", "New York", "Philadelphia", "Seattle", "San Francisco"].sorted()


    var body: some View {
        NavigationStack {
            Form {
                Section("Comunidades") {
                    Toggle("Mensajes", isOn: $messages)
                    Toggle("Invitaciones", isOn: $invitations)
                    Toggle("Miembros nuevos", isOn: $newMembers)
                    Toggle("Actualizaciones a puntos de reunión", isOn: $meetingUpdates)
                }
                Section("Noticias") {
                    Toggle("Resultados en vivo", isOn: $liveResults)
                    Toggle("Noticias relevanes en la ciudad", isOn: $localNews)
                    if localNews {
                        Picker("Ciudad seleccionada", selection: $selectedCity) {
                            ForEach(cities, id: \.self) { city in
                                Text(city)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Notificaciones")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Listo") { dismiss() }
                }
            }
        }
    }
}

struct PrivacyView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var phoneAvailable: Bool = UIApplication.shared.canOpenURL(URL(string: "tel://")!)
    @State private var locationStatus: CLAuthorizationStatus = CLLocationManager().authorizationStatus

    var body: some View {
        NavigationStack {
            Form {
                Section("Accesos de la aplicación") {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Teléfono")
                            Text(phoneAvailable ? "Accesible" : "No disponible")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        Image(systemName: phoneAvailable ? "phone.fill" : "phone.slash.fill")
                            .foregroundStyle(phoneAvailable ? .green : .red)
                    }

                    HStack {
                        VStack(alignment: .leading) {
                            Text("Ubicación (en tiempo real)")
                            Text(locationStatusDescription)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        Image(systemName: locationStatus == .authorizedAlways || locationStatus == .authorizedWhenInUse ? "location.fill" : "location.slash")
                            .foregroundStyle(locationStatus == .authorizedAlways || locationStatus == .authorizedWhenInUse ? .green : .red)
                    }
                }
            }
            .navigationTitle("Privacidad")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Listo") { dismiss() }
                }
            }
            .onAppear {
                locationStatus = CLLocationManager().authorizationStatus
                phoneAvailable = UIApplication.shared.canOpenURL(URL(string: "tel://")!)
            }
        }
    }

    private var locationStatusDescription: String {
        switch locationStatus {
        case .notDetermined: return "Sin determinar"
        case .restricted: return "Restringida"
        case .denied: return "Negada"
        case .authorizedAlways: return "Autorizada (siempre)"
        case .authorizedWhenInUse: return "Autorizada (cuando la app esta en uso)"
        @unknown default: return "Desconocido"
        }
    }
}

private func callNumber(_ number: String) {
    let cleaned = number
        .replacingOccurrences(of: " ", with: "")
        .replacingOccurrences(of: "-", with: "")
    
    if let url = URL(string: "tel://\(cleaned)"),
       UIApplication.shared.canOpenURL(url) {
        UIApplication.shared.open(url)
    }
}

struct TermsView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Cómo usamos tus datos").font(.title2).bold()
                    Text("Todos los datos en SafeFun se procesan y almacenan localmente en tu dispositivo, a menos que se indique explícitamente lo contrario. No vendemos datos de usuarios. A continuación se resumen los puntos clave:")
                    Group {
                        Text("• Ubicación: Se usa para mostrar tu posición en el mapa y los recursos cercanos. Los datos de ubicación se utilizan en tiempo real y no se suben por defecto.")
                        Text("• Contactos: Los contactos de emergencia se almacenan localmente para permitir llamadas / mensajes rápidos durante una emergencia.")
                        Text("• Mensajes y contenido comunitario: Los mensajes de la comunidad se almacenan localmente o en el servidor de la comunidad, dependiendo de la función. Los datos sensibles se minimizan.")
                    }
                    .font(.callout)
                    .foregroundStyle(.secondary)

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Enfoque local")
                            .font(.headline)
                        Text("La mayoría de las funciones usan un enfoque local para que tu dispositivo mantenga el control de los datos. Revisa siempre la comunidad o función específica si deseas optar por no participar.")
                            .font(.callout)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.top)

                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Términos y condiciones")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Listo") { dismiss() }
                }
            }
        }
    }
}

private func makePhoneCall(to number: String) {
    #if targetEnvironment(simulator)
    print("📱 Call simulation — would call \(number)")
    #else
    // Clean and prepare number
    let cleanedNumber = number
        .replacingOccurrences(of: " ", with: "")
        .replacingOccurrences(of: "-", with: "")
        .replacingOccurrences(of: "(", with: "")
        .replacingOccurrences(of: ")", with: "")
    
    guard let url = URL(string: "tel://\(cleanedNumber)") else { return }
    if UIApplication.shared.canOpenURL(url) {
        UIApplication.shared.open(url)
    } else {
        print("⚠️ Cannot open Phone app or invalid number.")
    }
    #endif
}

