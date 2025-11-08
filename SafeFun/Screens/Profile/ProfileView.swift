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
        team: "United States",
        emergencyContacts: [
            EmergencyContact(name: "Mom", phone: "1312345678"),
            EmergencyContact(name: "Dad", phone: "1287654321")
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
                        title: "Account",
                        rows: [
                            .init(icon: "person.text.rectangle", title: "Edit profile"),
                            .init(icon: "checkmark.seal.fill", title: "Verification"),
                            .init(icon: "mappin.and.ellipse", title: "Team: \(user.team)")
                        ],
                        onRowTapped: { rowTitle in
                            switch rowTitle {
                            case "Edit profile":
                                isShowingEditSheet = true
                            case "Verification":
                                // Show elegant modal
                                withAnimation(.spring()) {
                                    showVerificationModal = true
                                }
                            default:
                                if rowTitle.starts(with: "Team:") {
                                    // allow edit profile when tapping team
                                    isShowingEditSheet = true
                                }
                            }
                        }
                    )
                    
                    if !user.emergencyContacts.isEmpty {
                        ProfileSection(
                            title: "Emergency Contacts",
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
                        title: "Preferences",
                        rows: [
                            .init(icon: "bell.badge.fill", title: "Notifications"),
                            .init(icon: "hand.raised.fill", title: "Privacy"),
                        ],
                        onRowTapped: { rowTitle in
                            switch rowTitle {
                            case "Notifications":
                                showNotificationsScreen = true
                            case "Privacy":
                                showPrivacyScreen = true
                            default:
                                break
                            }
                        }
                    )
                    
                    // MARK: - Security
                    ProfileSection(
                        title: "Security",
                        rows: [
                            .init(icon: "list.bullet.rectangle.portrait.fill", title: "Terms & privacy")
                        ],
                        onRowTapped: { rowTitle in
                            if rowTitle == "Terms & privacy" {
                                showTermsScreen = true
                            } else if rowTitle == "Password & access" {
                                isShowingEditSheet = true
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
                            Text("Close")
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
        .alert("Call Simulation", isPresented: $showSimulatorAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("There's no Phone app on this simulator. On a physical device, tapping “Call 911” would call 811.")
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
                    StatPill(icon: "flag.fill", value: user.team, label: "Team", equalHeight: pillsEqualHeight)
                        .frame(width: (proxy.size.width - 32) / 2)
                    StatPill(icon: "bell.fill", value: "2", label: "Alerts", equalHeight: pillsEqualHeight)
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
                Text("Account Verified")
                    .font(.headline)
                    .foregroundStyle(.primary)
                Text("You can now access all the functionalities of the communities.")
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
    @State private var selectedCity = "Mexico City"
    private let cities = ["Toronto", "Vancouver", "Mexico City", "Guadalajara", "Monterrey", "Atlanta", "Boston", "Dallas", "Houston", "Kansas City", "Los Angeles", "Miami", "New York", "Philadelphia", "Seattle", "San Francisco"].sorted()


    var body: some View {
        NavigationStack {
            Form {
                Section("Communities") {
                    Toggle("Messages", isOn: $messages)
                    Toggle("Invitations", isOn: $invitations)
                    Toggle("New members", isOn: $newMembers)
                    Toggle("Updates to meeting points", isOn: $meetingUpdates)
                }
                Section("News") {
                    Toggle("Live results", isOn: $liveResults)
                    Toggle("Relevant news in my city", isOn: $localNews)
                    if localNews {
                        Picker("Selected city", selection: $selectedCity) {
                            ForEach(cities, id: \.self) { city in
                                Text(city)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Notifications")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
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
                Section("App Access") {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Phone")
                            Text(phoneAvailable ? "Accessible" : "Not available")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        Image(systemName: phoneAvailable ? "phone.fill" : "phone.slash.fill")
                            .foregroundStyle(phoneAvailable ? .green : .red)
                    }

                    HStack {
                        VStack(alignment: .leading) {
                            Text("Location (real-time)")
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
            .navigationTitle("Privacy")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
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
        case .notDetermined: return "Not determined"
        case .restricted: return "Restricted"
        case .denied: return "Denied"
        case .authorizedAlways: return "Authorized (always)"
        case .authorizedWhenInUse: return "Authorized (when in use)"
        @unknown default: return "Unknown"
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
                    Text("How we use your data")
                        .font(.title2).bold()
                    Text("All data in SafeFun is processed and stored locally on your device unless explicitly stated otherwise. We do not sell user data. The following summarizes key points:")
                    Group {
                        Text("• Location: Used to show your position on the map and nearby resources. Location data is used in real-time and is not uploaded by default.")
                        Text("• Contacts: Emergency contacts are stored locally to allow quick calling / messaging during an emergency.")
                        Text("• Messages and community content: Community messages are stored locally or in the community server depending on the feature. Sensitive data is minimized.")
                    }
                    .font(.callout)
                    .foregroundStyle(.secondary)

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Local-first approach")
                            .font(.headline)
                        Text("Most features use a local-first approach so your device stays in control of the data. Always check the specific community or feature if you want to opt-out.")
                            .font(.callout)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.top)

                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Terms & privacy")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
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

