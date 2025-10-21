//
//  CompleteProfileView.swift
//  SafeFun
//
//  Created by Hector Larios on 21/10/25.
//

import SwiftUI
import PhotosUI
internal import Combine

// Marca global opcional: si la usas, bájala a false al terminar.
// private let onboardingFlagKey = "needsProfileCompletion"

struct CompleteProfileView: View {
    var onFinish: (() -> Void)? = nil
    @StateObject private var vm = CompleteProfileVM()
    // Si usas AppStorage para esconder el modal al terminar:
    // @AppStorage(onboardingFlagKey) private var needsProfileCompletion: Bool = true
    @Environment(\.dismiss) private var dismiss
    @FocusState private var focused: Field?
    
    enum Field { case name, handle, phone, emergencyName, emergencyPhone }
    
    var body: some View {
        ZStack {
            BackgroundView() // reutiliza tu fondo actual

            VStack(spacing: 0) {
                // Encabezado
                VStack(spacing: 8) {
                    Text("Completa tu perfil")
                        .font(.title2.bold())
                    Text("Ayúdanos a personalizar tu experiencia.")
                        .font(.callout)
                        .foregroundStyle(.secondary)
                }
                .padding(.top, 24)

                // Contenido
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 16) {
                        AvatarPicker(image: $vm.avatar, selection: $vm.photoItem)

                        SectionCard(title: "Información básica") {
                            GlassField(systemIcon: "person.fill", placeholder: "Nombre", text: $vm.name)
                                .submitLabel(.next)
                                .focused($focused, equals: .name)
                                .onSubmit { focused = .handle }

                            GlassField(systemIcon: "at", placeholder: "Usuario (@handle)", text: $vm.handle)
                                .textInputAutocapitalization(.never)
                                .autocorrectionDisabled()
                                .submitLabel(.next)
                                .focused($focused, equals: .handle)
                                .onSubmit { focused = .phone }

                            // Hint de validación del handle
                            if !vm.handle.trimmed.isEmpty && !vm.isHandleValid {
                                Text("Usa 3–20 caracteres: letras, números, punto, guion y guion bajo. Puedes empezar con @.")
                                    .font(.footnote)
                                    .foregroundStyle(.red.opacity(0.9))
                                    .fixedSize(horizontal: false, vertical: true)
                            }

                            TeamPicker(selected: $vm.team)
                        }

                        SectionCard(title: "Contacto") {
                            GlassField(systemIcon: "phone.fill", placeholder: "Teléfono", text: $vm.phone, keyboard: .phonePad)
                                .focused($focused, equals: .phone)

                            Divider().opacity(0.15)

                            GlassField(systemIcon: "person.text.rectangle", placeholder: "Nombre contacto de emergencia", text: $vm.emergencyName)
                                .submitLabel(.next)
                                .focused($focused, equals: .emergencyName)
                                .onSubmit { focused = .emergencyPhone }

                            GlassField(systemIcon: "phone.arrow.up.right", placeholder: "Tel. contacto de emergencia", text: $vm.emergencyPhone, keyboard: .phonePad)
                                .focused($focused, equals: .emergencyPhone)
                        }

                        // Nota de privacidad
                        HStack(alignment: .top, spacing: 8) {
                            Image(systemName: "lock.shield")
                                .font(.headline)
                            Text("Solo usaremos tu contacto de emergencia para avisos críticos. Puedes cambiar esta información más tarde en **Perfil > Contacto de emergencia**.")
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
                    .padding(.bottom, 120)
                }

                // Barra inferior
                VStack(spacing: 10) {
                    Button {
                        Task { await finish(onSkip: true) }
                    } label: {
                        Text("Omitir por ahora")
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
                            Text(vm.isSaving ? "Guardando..." : "Continuar")
                                .bold()
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.wcPurple) // ajusta a tu paleta
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                    .disabled(!vm.canContinue || vm.isSaving)
                    .opacity(vm.canContinue ? 1 : 0.6)
                }
                .padding(.horizontal)
                .padding(.vertical, 16)
                .background(.ultraThinMaterial, in: Rectangle())
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Ocultar") { focused = nil }
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

    @Published var name: String = ""
    @Published var handle: String = ""
    @Published var team: String = ""
    @Published var phone: String = ""
    @Published var emergencyName: String = ""
    @Published var emergencyPhone: String = ""

    @Published var isSaving = false
    @Published var error: String?

    // Regex: permite opcionalmente un '@' al inicio
    let handleWithOptionalAtRegex = #"^@?[A-Za-z0-9._-]{3,20}$"#
    private let handleNormalizedRegex = #"^[A-Za-z0-9._-]{3,20}$"# // sin '@'

    /// Nombre + handle válidos para habilitar "Continuar"
    var canContinue: Bool {
        !name.trimmed.isEmpty && isHandleValid
    }

    /// ¿El handle (con o sin '@') es válido?
    var isHandleValid: Bool {
        handle.trimmed.matches(handleWithOptionalAtRegex)
    }
    var normalizedHandle: String {
        let h = handle.trimmed
        return h.hasPrefix("@") ? String(h.dropFirst()) : h
    }

    func loadDefaultsIfAny() {
        // precargar del user actual (ej. Firebase/Auth0), hazlo aquí.
    }

    func saveProfile() async throws {
        // Conecta capa de datos (API/Firestore/Realm). Ejemplo con latencia:
        try await Task.sleep(nanoseconds: 300_000_000)
        // Ejemplo de payload (usa normalizedHandle):
        // let payload = ["name": name.trimmed, "handle": normalizedHandle, "team": team, ...]
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
                Label("Elegir foto", systemImage: "camera.fill")
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
                .textContentType(.oneTimeCode) // neutral para evitar autocompletar agresivo
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
    private let teams = ["México", "Estados Unidos", "Canada", "Otro…"]

    var body: some View {
        Menu {
            Picker("team", selection: $selected) {
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

#Preview {
    NavigationStack {
        CompleteProfileView()
            .preferredColorScheme(.dark)
    }
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
