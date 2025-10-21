//
//  CommunitiesView.swift
//  SafeFun
//
//  Created by Lalo Cardenas on 19/10/25.
//

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

struct CommunitiesView: View {
    @State private var featured: [Community] = Community.sampleFeatured
    @State private var myCommunities: [Community] = Community.sampleMine
    @State private var showCreate: Bool = false

    // Navegación directa al chat tras crear
    @State private var navigateToCommunity: CommunityLite?

    var body: some View {
        NavigationStack {
            ZStack {
                BackgroundView()

                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 24) {

                        // Header sin botón Create
                        HStack {
                            Text("Communities")
                                .font(.largeTitle.bold())
                                .foregroundStyle(.primary)
                            Spacer()
                        }
                        .padding(.top, 8)
                        .padding(.horizontal)

                        // Featured section
                        VStack(alignment: .leading, spacing: 10) {
                            SectionHeader(title: "Featured communities")
                                .padding(.horizontal)

                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 16) {
                                    ForEach(featured) { community in
                                        NavigationLink {
                                            // Comunidades existentes: chat con mocks (isNew: false)
                                            ComunityChatView(community: community.toLite(), isNew: false)
                                        } label: {
                                            FeaturedCommunityCard(community: community)
                                        }
                                        .buttonStyle(.plain)
                                    }
                                }
                                .padding(.horizontal)
                                .padding(.bottom, 4)
                            }
                        }

                        // My communities section
                        VStack(alignment: .leading, spacing: 10) {
                            SectionHeader(title: "My communities")
                                .padding(.horizontal)

                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 18) {
                                    ForEach(myCommunities) { community in
                                        VStack(spacing: 8) {
                                            NavigationLink {
                                                // Comunidades existentes: chat con mocks (isNew: false)
                                                ComunityChatView(community: community.toLite(), isNew: false)
                                            } label: {
                                                CommunityCircleAvatar(community: community)
                                            }
                                            .buttonStyle(.plain)

                                            Text(community.name)
                                                .font(.caption)
                                                .foregroundStyle(.primary)
                                                .lineLimit(1)
                                                .frame(width: 72)
                                        }
                                    }
                                }
                                .padding(.horizontal)
                                .padding(.bottom, 8)
                            }
                        }

                        // Create block (único punto de creación)
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Start your own community")
                                .font(.headline)
                                .foregroundStyle(.primary)

                            Button {
                                showCreate = true
                            } label: {
                                HStack(spacing: 12) {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                                            .fill(LinearGradient(
                                                colors: [.wcPurple.opacity(0.35), .wcCyan.opacity(0.35)],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            ))
                                            .frame(width: 52, height: 52)
                                        Image(systemName: "plus")
                                            .font(.title3.bold())
                                            .foregroundStyle(.white)
                                    }

                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Create a community")
                                            .font(.subheadline.bold())
                                        Text("Gather people with shared interests or location.")
                                            .font(.footnote)
                                            .foregroundStyle(.secondary)
                                            .lineLimit(2)
                                    }

                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundStyle(.secondary)
                                }
                                .padding(14)
                                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .strokeBorder(.white.opacity(0.12), lineWidth: 1)
                                )
                            }
                            .buttonStyle(.plain)
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 24)
                    }
                    .padding(.top, 12)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            // Navegación programática al chat recién creado (Opción 1: Group + EmptyView)
            .background(
                NavigationLink(
                    isActive: Binding(
                        get: { navigateToCommunity != nil },
                        set: { isActive in
                            if !isActive { navigateToCommunity = nil }
                        }
                    ),
                    destination: {
                        Group {
                            if let lite = navigateToCommunity {
                                // Nueva comunidad: chat vacío (isNew: true)
                                ComunityChatView(community: lite, isNew: true)
                            } else {
                                EmptyView()
                            }
                        }
                    },
                    label: { EmptyView() }
                )
                .hidden()
            )
            .sheet(isPresented: $showCreate) {
                CreateCommunityView { newCommunity in
                    // Insertar al inicio de "My communities"
                    myCommunities.insert(newCommunity, at: 0)
                    // Navegar al chat vacío de la nueva comunidad
                    navigateToCommunity = newCommunity.toLite()
                }
                .presentationDetents([.medium, .large])
            }
        }
    }
}

// MARK: - Models (mock)

struct Community: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let emoji: String
    let members: Int
    let featured: Bool
    let color: Color

    func toLite() -> CommunityLite {
        CommunityLite(id: id, name: name, emoji: emoji)
    }

    static let sampleFeatured: [Community] = [
        .init(name: "NYC Fans", emoji: "🗽", members: 1280, featured: true, color: .purple),
        .init(name: "CDMX Safe", emoji: "🦅", members: 980, featured: true, color: .blue),
        .init(name: "Toronto Hub", emoji: "🍁", members: 640, featured: true, color: .red),
        .init(name: "LA Watch", emoji: "🌴", members: 720, featured: true, color: .orange)
    ]

    static let sampleMine: [Community] = [
        .init(name: "Roommates", emoji: "🏠", members: 6, featured: false, color: .teal),
        .init(name: "Fan Club", emoji: "⚽️", members: 24, featured: false, color: .green),
        .init(name: "Volunteers", emoji: "🤝", members: 18, featured: false, color: .pink),
        .init(name: "Neighbors", emoji: "🏘️", members: 12, featured: false, color: .indigo)
    ]
}

// MARK: - Components

private struct SectionHeader: View {
    let title: String
    var body: some View {
        HStack {
            Text(title)
                .font(.title2.bold())
                .foregroundStyle(.primary)
            Spacer()
        }
    }
}

private struct FeaturedCommunityCard: View {
    let community: Community

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Top image/emoji area
            ZStack {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [community.color.opacity(0.55), .wcCyan.opacity(0.45)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(height: 120)
                Text(community.emoji)
                    .font(.system(size: 44))
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(community.name)
                    .font(.headline)
                    .foregroundStyle(.primary)
                    .lineLimit(1)
                HStack(spacing: 6) {
                    Image(systemName: "person.3.fill")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text("\(community.members) members")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .frame(width: 240)
        .padding(12)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .strokeBorder(.white.opacity(0.12), lineWidth: 1)
        )
        .shadow(radius: 12, y: 6)
    }
}

private struct CommunityCircleAvatar: View {
    let community: Community

    var body: some View {
        ZStack {
            Circle()
                .fill(
                    LinearGradient(
                        colors: [community.color.opacity(0.5), .wcPurple.opacity(0.35)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 72, height: 72)
            Text(community.emoji)
                .font(.system(size: 28))
        }
        .overlay(
            Circle()
                .strokeBorder(.white.opacity(0.18), lineWidth: 1)
        )
        .shadow(radius: 8, y: 4)
    }
}

// Create view mejorada y simplificada (Details: solo nombre y privada)
struct CreateCommunityView: View {
    @Environment(\.dismiss) private var dismiss

    // Callback para notificar la nueva comunidad al padre
    var onCreate: (Community) -> Void = { _ in }

    @State private var name: String = ""
    @State private var isPrivate: Bool = false

    // Tags (se mantienen como pediste)
    @State private var tagInput: String = ""
    @State private var tags: [String] = []

    // Invitación (se mantiene como pediste)
    @State private var invitationID: UUID?
    @State private var invitationURL: URL?
    @State private var qrImage: Image?
    @State private var showCopiedToast: Bool = false

    private let context = CIContext()
    private let qrFilter = CIFilter.qrCodeGenerator()

    var body: some View {
        NavigationStack {
            ZStack {
                BackgroundView()
                Form {
                    // Solo nombre y switch privada
                    Section("Details") {
                        TextField("Community name", text: $name)
                        Toggle("Private community", isOn: $isPrivate)
                    }

                    Section("Tags") {
                        HStack(spacing: 8) {
                            TextField("Add a tag (e.g. fútbol, vecinos)", text: $tagInput, onCommit: addTag)
                                .textInputAutocapitalization(.never)
                                .autocorrectionDisabled(true)
                            Button("Add") { addTag() }
                                .disabled(tagInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                        }

                        if !tags.isEmpty {
                            WrappingTagsView(tags: tags, onRemove: removeTag)
                                .padding(.vertical, 4)
                        } else {
                            Text("No tags yet").foregroundStyle(.secondary)
                        }
                    }

                    Section("Invitation") {
                        if let url = invitationURL {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Invite link")
                                    .font(.subheadline.weight(.semibold))
                                HStack(spacing: 8) {
                                    Text(url.absoluteString)
                                        .font(.footnote)
                                        .lineLimit(2)
                                        .textSelection(.enabled)
                                    Spacer()
                                    Button {
                                        UIPasteboard.general.string = url.absoluteString
                                        withAnimation { showCopiedToast = true }
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                                            withAnimation { showCopiedToast = false }
                                        }
                                    } label: {
                                        Image(systemName: "doc.on.doc")
                                    }
                                    if #available(iOS 16.0, *) {
                                        ShareLink(item: url) {
                                            Image(systemName: "square.and.arrow.up")
                                        }
                                    }
                                }

                                if let qr = qrImage {
                                    VStack(alignment: .leading, spacing: 6) {
                                        Text("QR code")
                                            .font(.subheadline.weight(.semibold))
                                        qr
                                            .resizable()
                                            .interpolation(.none)
                                            .scaledToFit()
                                            .frame(maxWidth: 220)
                                            .padding(8)
                                            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                                    }
                                }
                            }
                        } else {
                            Button {
                                generateInvitation()
                            } label: {
                                Text("Generate invitation")
                            }
                            .disabled(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                        }
                    }

                    Section {
                        Button {
                            // Crear la comunidad y notificar al padre
                            let new = Community(
                                name: name.trimmingCharacters(in: .whitespacesAndNewlines),
                                emoji: "👥", // emoji fijo para mock; puedes mapear por tags o elegir aleatorio
                                members: 1,
                                featured: false,
                                color: randomCommunityColor()
                            )
                            onCreate(new)
                            dismiss()
                        } label: {
                            Text("Create")
                                .frame(maxWidth: .infinity, alignment: .center)
                        }
                        .disabled(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    }
                }
                .scrollContentBackground(.hidden)

                if showCopiedToast {
                    VStack {
                        Spacer()
                        Text("Link copied")
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                            .background(.ultraThinMaterial, in: Capsule())
                            .overlay(Capsule().strokeBorder(.white.opacity(0.12), lineWidth: 1))
                            .padding(.bottom, 24)
                    }
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
            .navigationTitle("Create community")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }

    private func addTag() {
        let trimmed = tagInput.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        guard !tags.contains(where: { $0.caseInsensitiveCompare(trimmed) == .orderedSame }) else {
            tagInput = ""
            return
        }
        tags.append(trimmed)
        tagInput = ""
    }

    private func removeTag(_ tag: String) {
        tags.removeAll { $0 == tag }
    }

    private func generateInvitation() {
        let id = UUID()
        invitationID = id
        // Ajusta dominio/esquema a tu backend real
        let url = URL(string: "https://safefun.app/join/\(id.uuidString)")!
        invitationURL = url
        qrImage = makeQRCode(from: url.absoluteString)
    }

    private func makeQRCode(from string: String) -> Image? {
        let data = Data(string.utf8)
        qrFilter.message = data
        qrFilter.correctionLevel = "M"

        guard let outputImage = qrFilter.outputImage else { return nil }
        let transform = CGAffineTransform(scaleX: 8, y: 8)
        let scaledImage = outputImage.transformed(by: transform)

        if let cgimg = context.createCGImage(scaledImage, from: scaledImage.extent) {
            return Image(uiImage: UIImage(cgImage: cgimg))
        }
        return nil
    }

    private func randomCommunityColor() -> Color {
        // Usa tu set de colores de marca si quieres
        let palette: [Color] = [.teal, .green, .indigo, .pink, .orange, .purple, .blue, .red]
        return palette.randomElement() ?? .teal
    }
}

// Vista de chips de tags con wrap
private struct WrappingTagsView: View {
    let tags: [String]
    var onRemove: (String) -> Void

    @State private var totalHeight = CGFloat.zero

    var body: some View {
        self.generateContent()
            .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func generateContent() -> some View {
        var width = CGFloat.zero
        var height = CGFloat.zero

        return ZStack(alignment: .topLeading) {
            ForEach(tags, id: \.self) { tag in
                tagChip(tag)
                    .padding([.horizontal, .vertical], 4)
                    .alignmentGuide(.leading, computeValue: { d in
                        if abs(width - d.width) > UIScreen.main.bounds.width - 64 {
                            width = 0
                            height -= d.height
                        }
                        let result = width
                        if tag == tags.last {
                            width = 0
                        } else {
                            width -= d.width
                        }
                        return result
                    })
                    .alignmentGuide(.top, computeValue: { _ in
                        let result = height
                        if tag == tags.last {
                            height = 0
                        }
                        return result
                    })
            }
        }
        .background(viewHeightReader($totalHeight))
    }

    private func tagChip(_ text: String) -> some View {
        HStack(spacing: 6) {
            Text(text)
                .font(.footnote)
            Button {
                onRemove(text)
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(.ultraThinMaterial, in: Capsule())
        .overlay(Capsule().strokeBorder(.white.opacity(0.12), lineWidth: 1))
    }

    private func viewHeightReader(_ binding: Binding<CGFloat>) -> some View {
        GeometryReader { geometry in
            Color.clear
                .preference(key: ViewHeightKey.self, value: geometry.size.height)
        }
        .onPreferenceChange(ViewHeightKey.self) { height in
            binding.wrappedValue = height
        }
    }

    private struct ViewHeightKey: PreferenceKey {
        static var defaultValue: CGFloat = 0
        static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
            value = max(value, nextValue())
        }
    }
}

#Preview {
    CommunitiesView()
}
