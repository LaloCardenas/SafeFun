//
//  CommunitiesView.swift
//  SafeFun
//
//  Created by Lalo Cardenas on 19/10/25.
//

import SwiftUI

struct CommunitiesView: View {
    @State private var featured: [Community] = Community.sampleFeatured
    @State private var myCommunities: [Community] = Community.sampleMine
    @State private var showCreate: Bool = false

    var body: some View {
        NavigationStack {
            ZStack {
                BackgroundView()

                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 24) {

                        // Header + Create button
                        HStack {
                            Text("Communities")
                                .font(.largeTitle.bold())
                                .foregroundStyle(.primary)
                            Spacer()
                            Button {
                                showCreate = true
                            } label: {
                                HStack(spacing: 8) {
                                    Image(systemName: "plus.circle.fill")
                                    Text("Create")
                                        .fontWeight(.semibold)
                                }
                                .padding(.horizontal, 14)
                                .padding(.vertical, 10)
                                .background(.ultraThinMaterial)
                                .clipShape(Capsule())
                            }
                            .buttonStyle(.plain)
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
                                            ComunityChatView(community: community.toLite())
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
                                                ComunityChatView(community: community.toLite())
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

                        // Create block (secondary entry point)
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Start your own community")
                                .font(.headline)
                                .foregroundStyle(.primary)

                            NavigationLink {
                                CreateCommunityView()
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
            .sheet(isPresented: $showCreate) {
                CreateCommunityView()
                    .presentationDetents([.medium, .large])
            }
        }
    }
}

// MARK: - Models (mock)

private struct Community: Identifiable, Hashable {
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

// Create view ya está en este archivo como en tu versión actual
struct CreateCommunityView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var name: String = ""
    @State private var emoji: String = "🎯"
    @State private var isPrivate: Bool = false

    var body: some View {
        NavigationStack {
            ZStack {
                BackgroundView()
                Form {
                    Section("Details") {
                        TextField("Community name", text: $name)
                        TextField("Emoji", text: $emoji)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled(true)
                        Toggle("Private community", isOn: $isPrivate)
                    }

                    Section {
                        Button {
                            // TODO: Guardar en tu backend
                            dismiss()
                        } label: {
                            Text("Create")
                                .frame(maxWidth: .infinity, alignment: .center)
                        }
                    }
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("Create community")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }
}

#Preview {
    CommunitiesView()
}
