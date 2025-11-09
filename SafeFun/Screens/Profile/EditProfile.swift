//
//  EditProfileView.swift
//  SafeFun
//
//  Created by Lalo Cardenas on 20/10/25.
//

import SwiftUI
import PhotosUI

struct EditProfileView: View {
    
    @Binding var user: User
    
    @State private var avatar: Image? = nil
    @State private var photoItem: PhotosPickerItem? = nil
    
    @Environment(\.dismiss) var dismiss
    
    @State private var originalUser: User

    init(user: Binding<User>) {
        self._user = user
        self._originalUser = State(initialValue: user.wrappedValue)
    }

    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 16) {
                        
                        SectionCard(title: "Información básica") {
                            GlassField(systemIcon: "person.fill", placeholder: "Nombre", text: $user.firstName)
                            GlassField(systemIcon: "person.fill", placeholder: "Apellido", text: $user.lastName)
                            GlassField(systemIcon: "at", placeholder: "Nombre de usuario", text: $user.username)
                                .textInputAutocapitalization(.never)
                                .autocorrectionDisabled()
                            
                            TeamPicker(selected: $user.team)
                        }

                        SectionCard(title: "Contactos de emergencia") {
                            ForEach($user.emergencyContacts) { $contact in
                                VStack {
                                    GlassField(systemIcon: "person.text.rectangle", placeholder: "Nombre del contacto", text: $contact.name)
                                    GlassField(systemIcon: "phone.fill", placeholder: "Número del contacto", text: $contact.phone, keyboard: .phonePad)
                                }
                                .padding(.bottom, 5)
                            }
                            .onDelete(perform: deleteContact)
                            
                            Button(action: addContact) {
                                Label("Agregar contacto", systemImage: "plus.circle.fill")
                                    .font(.callout.bold())
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 10)
                                    .background(.white.opacity(0.1))
                                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                            }
                            .buttonStyle(.plain)
                        }

                    }
                    .padding(.horizontal)
                    .padding(.top, 16)
                    .padding(.bottom, 24)
                }
            }
            .navigationTitle("Editar perfil")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") {
                        user = originalUser
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Guardar") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func addContact() {
        let newContact = EmergencyContact(name: "", phone: "")
        user.emergencyContacts.append(newContact)
    }
    
    private func deleteContact(at offsets: IndexSet) {
        user.emergencyContacts.remove(atOffsets: offsets)
    }
}


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
                    img.resizable().scaledToFill().frame(width: 112, height: 112).clipShape(Circle())
                } else {
                    Image(systemName: "person.crop.circle.fill").resizable().scaledToFit().frame(width: 112, height: 112).foregroundStyle(.secondary)
                }
            }

            PhotosPicker(selection: $selection, matching: .images) {
                Label("Elegir foto", systemImage: "camera.fill")
                    .font(.callout.bold()).padding(.vertical, 8).padding(.horizontal, 14)
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
        "México", "United States", "Canada",
        "Algeria", "Argentina", "Australia", "Austria", "Belgium", "Brazil",
        "Cameroon", "Chile", "Colombia", "Costa Rica", "Croatia", "Denmark",
        "Ecuador", "Egypt", "England", "France", "Germany", "Ghana", "Iran",
        "Italy", "Ivory Coast", "Jamaica", "Japan", "Mali", "Morocco",
        "Netherlands", "New Zealand", "Nigeria", "Panama", "Paraguay", "Peru",
        "Poland", "Portugal", "Qatar", "Saudi Arabia", "Senegal", "Serbia",
        "South Korea", "Spain", "Sweden", "Switzerland", "Tunisia", "Ukraine",
        "Uruguay", "Uzbekistan",
    ]

    var body: some View {
        Menu {
            Picker("team", selection: $selected) {
                Text("Elige tu selección").tag("")
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


// MARK: - Preview
#Preview {
    EditProfileView(user: .constant(
        User(
            firstName: "Héctor",
            lastName: "Larios",
            username: "heclarios",
            team: "USA",
            emergencyContacts: []
        )
    ))
    .preferredColorScheme(.dark)
}
