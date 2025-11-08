//
//  CompleteProfileView.swift
//  SafeFun
//
//  Created by Hector Larios on 21/10/25.
//

import SwiftUI
import PhotosUI
internal import Combine


struct CompleteProfileView: View {
    var onFinish: (() -> Void)? = nil
    @StateObject private var vm = CompleteProfileVM()

    @Environment(\.dismiss) private var dismiss
    @FocusState private var focused: Field?
    
    enum Field { case name, lastName, handle, phone, emergencyName, emergencyPhone }
    
    var body: some View {
        ZStack {
            BackgroundView() // Asumimos que este View existe

            VStack(spacing: 0) {
                VStack(spacing: 8) {
                    Text("Complete your profile")
                        .font(.title2.bold())
                    Text("Help us personalize your experience.")
                        .font(.callout)
                        .foregroundStyle(.secondary)
                }
                .padding(.top, 24)

                // Contenido
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 16) {
                        AvatarPicker(image: $vm.avatar, selection: $vm.photoItem)

                        SectionCard(title: "Basic information") {
                            GlassField(systemIcon: "person.fill", placeholder: "First Name", text: $vm.firstName)
                                .submitLabel(.next)
                                .focused($focused, equals: .name)
                                .onSubmit { focused = .lastName }

                            GlassField(systemIcon: "person.fill", placeholder: "Last Name", text: $vm.lastName)
                                .submitLabel(.next)
                                .focused($focused, equals: .lastName)
                                .onSubmit { focused = .handle }

                            GlassField(systemIcon: "at", placeholder: "Username", text: $vm.username)
                                .textInputAutocapitalization(.never)
                                .autocorrectionDisabled()
                                .submitLabel(.next)
                                .focused($focused, equals: .handle)
                                .onSubmit { focused = .phone }

                            if !vm.username.trimmed.isEmpty && !vm.isUsernameValid {
                                Text("Use 3–20 characters: letters, numbers, dot, hyphen, or underscore. You may start with @.")
                                    .font(.footnote)
                                    .foregroundStyle(.red.opacity(0.9))
                                    .fixedSize(horizontal: false, vertical: true)
                            }

                            TeamPicker(selected: $vm.team)
                        }

                        SectionCard(title: "Contact") {
                            GlassField(systemIcon: "phone.fill", placeholder: "Phone", text: $vm.phone, keyboard: .phonePad)
                                .focused($focused, equals: .phone)

                            Divider().opacity(0.15)

                            GlassField(systemIcon: "person.text.rectangle", placeholder: "Emergency contact name", text: $vm.emergencyName)
                                .submitLabel(.next)
                                .focused($focused, equals: .emergencyName)
                                .onSubmit { focused = .emergencyPhone }

                            CountryCodePhoneField(
                                countries: CountryData.list,
                                selectedCode: $vm.emergencyCountryCode,
                                number: $vm.emergencyPhone,
                                placeholder: "Emergency contact phone"
                            )
                            .focused($focused, equals: .emergencyPhone)
                        }

                        // Nota de privacidad
                        HStack(alignment: .top, spacing: 8) {
                            Image(systemName: "lock.shield")
                                .font(.headline)
                            Text("We’ll only use your emergency contact for critical alerts. You can change this anytime in **Profile > Emergency contact**.")
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                        }
                        .padding(12)
                        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 14).stroke(.white.opacity(0.12), lineWidth: 1)
                        )
                    }
                    .padding(.horizontal)
                    .padding(.top, 16)
                    .padding(.bottom, 16)
                    
                    // Botones (Estáticos al final del scroll)
                    VStack(spacing: 10) {
                        Button {
                            Task { await finish(onSkip: true) }
                        } label: {
                            Text("Skip for now")
                                .font(.callout)
                                .underline()
                                .foregroundStyle(.secondary)
                        }
                        .buttonStyle(.plain)

                        Button {
                            Task { await finish(onSkip: false) }
                        } label: {
                            HStack {
                                if vm.isSaving { ProgressView().tint(.white) }
                                Text(vm.isSaving ? "Saving..." : "Continue")
                                    .bold()
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.wcPurple) // Asumimos que este color existe
                        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                        .disabled(!vm.canContinue || vm.isSaving)
                        .opacity(vm.canContinue ? 1 : 0.6)
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 16)
                    .background(.ultraThinMaterial, in: Rectangle())
                } // <-- Fin del ScrollView
                
            } // <-- Fin de VStack(spacing: 0)
        }
        // --- ¡CAMBIO AQUÍ! ---
        // Esto le dice a SwiftUI que NO anime los cambios de foco.
        .animation(nil, value: focused)
        // --- FIN DEL CAMBIO ---
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Hide") { focused = nil }
            }
        }
        .onAppear { vm.loadDefaultsIfAny() }
    }

    private func finish(onSkip: Bool) async {
        focused = nil
        vm.isSaving = true
        defer { vm.isSaving = false }

        do {
            if !onSkip {
                try await vm.saveProfile()
            }
            dismiss()
            onFinish?()
        } catch {
            vm.error = error.localizedDescription
        }
    }
}

// MARK: - ViewModel

final class CompleteProfileVM: ObservableObject {
    @Published var avatar: Image? = nil
    @Published var photoItem: PhotosPickerItem? = nil {
        didSet { Task { await loadImage() } }
    }

    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var username: String = ""
    
    @Published var team: String = ""
    @Published var phone: String = ""
    
    @Published var emergencyName: String = ""
    @Published var emergencyCountryCode: String = "+52" // Default anfitrión
    @Published var emergencyPhone: String = ""

    @Published var isSaving = false
    @Published var error: String?

    let usernameWithOptionalAtRegex = #"^@?[A-Za-z0-9._-]{3,20}$"#
    private let usernameNormalizedRegex = #"^[A-Za-z0-9._-]{3,20}$"#

    var canContinue: Bool {
        !firstName.trimmed.isEmpty && !lastName.trimmed.isEmpty && isUsernameValid
    }

    var isUsernameValid: Bool {
        username.trimmed.matches(usernameWithOptionalAtRegex)
    }
    
    var normalizedUsername: String {
        let u = username.trimmed
        return u.hasPrefix("@") ? String(u.dropFirst()) : u
    }

    func loadDefaultsIfAny() {
        // precargar del user actual
    }

    func saveProfile() async throws {
        let initialContact: EmergencyContact?
        let fullEmergencyPhone = "\(emergencyCountryCode)\(emergencyPhone.trimmed)"
        
        if !emergencyName.trimmed.isEmpty && !emergencyPhone.trimmed.isEmpty {
            initialContact = EmergencyContact(
                name: emergencyName.trimmed,
                phone: fullEmergencyPhone
            )
        } else {
            initialContact = nil
        }
        
        let userToSave = User(
            firstName: self.firstName.trimmed,
            lastName: self.lastName.trimmed,
            username: self.normalizedUsername,
            team: self.team,
            emergencyContacts: initialContact != nil ? [initialContact!] : []
        )
        
        print("Guardando usuario con contacto: \(userToSave)")
        
        try await Task.sleep(nanoseconds: 300_000_000)
    }

    @MainActor
    private func loadImage() async {
        guard let item = photoItem else { return }
        do {
            if let data = try await item.loadTransferable(type: Data.self),
               let ui = UIImage(data: data) {
                avatar = Image(uiImage: ui)
            }
        } catch {
            self.error = "No se pudo cargar la imagen."
        }
    }
}

// MARK: - Subviews

private struct AvatarPicker: View {
    @Binding var image: Image?
    @Binding var selection: PhotosPickerItem?

    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(.ultraThinMaterial)
                    .frame(width: 120, height: 120)
                    .shadow(color: .black.opacity(0.25), radius: 18, y: 8)
                    .overlay(
                        Circle().strokeBorder(
                            AngularGradient(gradient: Gradient(colors: [.wcGold, .wcPurple, .wcCyan, .wcBlue]), center: .center),
                            lineWidth: 4
                        )
                    )

                if let img = image {
                    img
                        .resizable()
                        .scaledToFill()
                        .frame(width: 112, height: 112)
                        .clipShape(Circle())
                } else {
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 112, height: 112)
                        .foregroundStyle(.secondary)
                }
            }

            PhotosPicker(selection: $selection, matching: .images) {
                Label("Choose photo", systemImage: "camera.fill")
                    .font(.callout.bold())
                    .padding(.vertical, 8)
                    .padding(.horizontal, 14)
                    .background(.ultraThinMaterial, in: Capsule())
                    .overlay(Capsule().stroke(.white.opacity(0.2), lineWidth: 1))
            }
        }
        .accessibilityElement(children: .combine)
    }
}

private struct SectionCard<Content: View>: View {
    let title: String
    let content: Content

    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
                .foregroundStyle(.secondary)
                .padding(.horizontal, 6)

            VStack(spacing: 10) {
                content
            }
            .padding(14)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 18).stroke(.white.opacity(0.1), lineWidth: 1)
            )
            .shadow(radius: 12, y: 6)
        }
    }
}

private struct GlassField: View {
    let systemIcon: String
    let placeholder: String
    @Binding var text: String
    var keyboard: UIKeyboardType = .default

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: systemIcon)
                .font(.headline)

            TextField(placeholder, text: $text)
                .textContentType(.oneTimeCode)
                .keyboardType(keyboard)
                .textInputAutocapitalization(.words)
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 12)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 14).stroke(.white.opacity(0.12), lineWidth: 1)
        )
    }
}

private struct TeamPicker: View {
    @Binding var selected: String
    
    private let teams = [
        "Mexico", "United States", "Canada",
        "Algeria", "Argentina", "Australia", "Austria", "Belgium", "Brazil",
        "Cameroon", "Chile", "Colombia", "Costa Rica", "Croatia", "Denmark",
        "Ecuador", "Egypt", "England", "France", "Germany", "Ghana", "Iran",
        "Italy", "Ivory Coast", "Jamaica", "Japan", "Mali", "Morocco",
        "Netherlands", "New Zealand", "Nigeria", "Panama", "Paraguay", "Peru",
        "Poland", "Portugal", "Qatar", "Saudi Arabia", "Senegal", "Serbia",
        "South Korea", "Spain", "Sweden", "Switzerland", "Tunisia", "Ukraine",
        "Uruguay", "Uzbekistan"
    ]

    var body: some View {
        Menu {
            Picker("team", selection: $selected) {
                Text("Select Team").tag("")
                ForEach(teams, id: \.self) { Text($0).tag($0) }
            }
        } label: {
            HStack(spacing: 12) {
                Image(systemName: "mappin.and.ellipse")
                    .font(.headline)
                Text(selected.isEmpty ? "Team" : selected)
                    .foregroundStyle(selected.isEmpty ? .secondary : .primary)
                Spacer()
                Image(systemName: "chevron.up.chevron.down")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 12)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 14).stroke(.white.opacity(0.12), lineWidth: 1)
            )
        }
    }
}

private struct CountryCodePhoneField: View {
    let countries: [Country]
    @Binding var selectedCode: String
    @Binding var number: String
    let placeholder: String
    
    private var selectedCountry: Country? {
        countries.first { $0.dialCode == selectedCode }
    }
    
    private var defaultCountry: Country {
        .init(name: "Select", dialCode: "+?", flag: "🌎")
    }

    var body: some View {
        HStack(spacing: 12) {
            Menu {
                Picker("Country Code", selection: $selectedCode) {
                    Section("Hosts") {
                        ForEach(countries.prefix(3)) { country in
                            Text("\(country.flag) \(country.name) (\(country.dialCode))")
                                .tag(country.dialCode)
                        }
                    }
                    Section {
                        ForEach(countries.dropFirst(3)) { country in
                            Text("\(country.flag) \(country.name) (\(country.dialCode))")
                                .tag(country.dialCode)
                        }
                    }
                }
            } label: {
                let country = selectedCountry ?? defaultCountry
                HStack(spacing: 4) {
                    Text(country.flag)
                    Text(country.dialCode)
                        .font(.headline)
                        .foregroundStyle(.primary)
                }
            }
            .buttonStyle(.plain)

            TextField(placeholder, text: $number)
                .textContentType(.telephoneNumber)
                .keyboardType(.phonePad)
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 12)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 14).stroke(.white.opacity(0.12), lineWidth: 1)
        )
    }
}


#Preview {
    NavigationStack {
        CompleteProfileView()
            .preferredColorScheme(.dark)
    }
}

private struct Country: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let dialCode: String
    let flag: String
}

private struct CountryData {
    static let list: [Country] = [
        .init(name: "Mexico", dialCode: "+52", flag: "🇲🇽"),
        .init(name: "United States", dialCode: "+1", flag: "🇺🇸"),
        .init(name: "Canada", dialCode: "+1", flag: "🇨🇦"),
        .init(name: "Algeria", dialCode: "+213", flag: "🇩🇿"),
        .init(name: "Argentina", dialCode: "+54", flag: "🇦🇷"),
        .init(name: "Australia", dialCode: "+61", flag: "🇦🇺"),
        .init(name: "Austria", dialCode: "+43", flag: "🇦🇹"),
        .init(name: "Belgium", dialCode: "+32", flag: "🇧🇪"),
        .init(name: "Brazil", dialCode: "+55", flag: "🇧🇷"),
        .init(name: "Cameroon", dialCode: "+237", flag: "🇨🇲"),
        .init(name: "Chile", dialCode: "+56", flag: "🇨🇱"),
        .init(name: "Colombia", dialCode: "+57", flag: "🇨🇴"),
        .init(name: "Costa Rica", dialCode: "+506", flag: "🇨🇷"),
        .init(name: "Croatia", dialCode: "+385", flag: "🇭🇷"),
        .init(name: "Denmark", dialCode: "+45", flag: "🇩🇰"),
        .init(name: "Ecuador", dialCode: "+593", flag: "🇪🇨"),
        .init(name: "Egypt", dialCode: "+20", flag: "🇪🇬"),
        .init(name: "England", dialCode: "+44", flag: "🏴󠁧󠁢󠁥󠁮󠁧󠁿"),
        .init(name: "France", dialCode: "+33", flag: "🇫🇷"),
        .init(name: "Germany", dialCode: "+49", flag: "🇩🇪"),
        .init(name: "Ghana", dialCode: "+233", flag: "🇬🇭"),
        .init(name: "Iran", dialCode: "+98", flag: "🇮🇷"),
        .init(name: "Italy", dialCode: "+39", flag: "🇮🇹"),
        .init(name: "Ivory Coast", dialCode: "+225", flag: "🇨🇮"),
        .init(name: "Jamaica", dialCode: "+1", flag: "🇯🇲"),
        .init(name: "Japan", dialCode: "+81", flag: "🇯🇵"),
        .init(name: "Mali", dialCode: "+223", flag: "🇲🇱"),
        .init(name: "Morocco", dialCode: "+212", flag: "🇲🇦"),
        .init(name: "Netherlands", dialCode: "+31", flag: "🇳🇱"),
        .init(name: "New Zealand", dialCode: "+64", flag: "🇳🇿"),
        .init(name: "Nigeria", dialCode: "+234", flag: "🇳🇬"),
        .init(name: "Panama", dialCode: "+507", flag: "🇵🇦"),
        .init(name: "Paraguay", dialCode: "+595", flag: "🇵🇾"),
        .init(name: "Peru", dialCode: "+51", flag: "🇵🇪"),
        .init(name: "Poland", dialCode: "+48", flag: "🇵🇱"),
        .init(name: "Portugal", dialCode: "+351", flag: "🇵🇹"),
        .init(name: "Qatar", dialCode: "+974", flag: "🇶🇦"),
        .init(name: "Saudi Arabia", dialCode: "+966", flag: "🇸🇦"),
        .init(name: "Senegal", dialCode: "+221", flag: "🇸🇳"),
        .init(name: "Serbia", dialCode: "+381", flag: "🇷🇸"),
        .init(name: "South Korea", dialCode: "+82", flag: "🇰🇷"),
        .init(name: "Spain", dialCode: "+34", flag: "🇪🇸"),
        .init(name: "Sweden", dialCode: "+46", flag: "🇸🇪"),
        .init(name: "Switzerland", dialCode: "+41", flag: "🇨🇭"),
        .init(name: "Tunisia", dialCode: "+216", flag: "🇹🇳"),
        .init(name: "Ukraine", dialCode: "+380", flag: "🇺🇦"),
        .init(name: "Uruguay", dialCode: "+598", flag: "🇺🇾"),
        .init(name: "Uzbekistan", dialCode: "+998", flag: "🇺🇿")
    ]
}

// MARK: - Utilidades

extension String {
    var trimmed: String {
        trimmingCharacters(in: .whitespacesAndNewlines)
    }

    func matches(_ pattern: String) -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: pattern)
            let range = NSRange(location: 0, length: utf16.count)
            return regex.firstMatch(in: self, range: range) != nil
        } catch {
            print("Regex inválido: \(error)")
            return false
        }
    }
}
