//
//  ComunityChatView.swift
//  SafeFun
//
//  Created by Lalo Cardenas on 21/10/25.
//

import SwiftUI

// Un modelo ligero para representar la comunidad seleccionada
struct CommunityLite: Identifiable, Hashable {
    let id: UUID
    let name: String
    let emoji: String
}

// Modelo de mensaje
struct ChatMessage: Identifiable, Hashable {
    let id = UUID()
    let authorName: String
    let text: String
    let timestamp: Date
    let isCurrentUser: Bool
}

struct ComunityChatView: View {
    let community: CommunityLite
    @Environment(\.dismiss) private var dismiss

    @State private var messages: [ChatMessage] = [
        ChatMessage(authorName: "Ana",   text: "Hi everyone 👋",                               timestamp: Date().addingTimeInterval(-3600), isCurrentUser: false),
        ChatMessage(authorName: "Luis",  text: "Is anyone going to the fan fest today?",       timestamp: Date().addingTimeInterval(-3400), isCurrentUser: false),
        ChatMessage(authorName: "You",   text: "I'll be there around 6pm.",                    timestamp: Date().addingTimeInterval(-3300), isCurrentUser: true),
        ChatMessage(authorName: "Maria", text: "Great, let's meet at the main entrance 🚪",    timestamp: Date().addingTimeInterval(-3200), isCurrentUser: false),
        ChatMessage(authorName: "You",   text: "Any parking recommendations?",                 timestamp: Date().addingTimeInterval(-3100), isCurrentUser: true),
        ChatMessage(authorName: "Carlos",text: "Lot B is usually less crowded.",               timestamp: Date().addingTimeInterval(-3000), isCurrentUser: false)
    ]

    @State private var draft: String = ""
    @FocusState private var inputFocused: Bool

    var body: some View {
        ZStack {
            BackgroundView()
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Header con botón de Back, emoji y nombre
                HStack(spacing: 10) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.headline)
                            .foregroundStyle(.primary)
                            .padding(8)
                            .background(.ultraThinMaterial)
                            .clipShape(Circle())
                    }
                    .buttonStyle(.plain)

                    Text(community.emoji)
                        .font(.system(size: 28))

                    VStack(alignment: .leading, spacing: 2) {
                        Text(community.name)
                            .font(.headline)
                        Text("Community chat")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
                .background(.ultraThinMaterial)
                .overlay(
                    Rectangle()
                        .frame(height: 0.5)
                        .foregroundStyle(.white.opacity(0.18)),
                    alignment: .bottom
                )

                // Mensajes
                ChatMessagesList(messages: messages)
                    .onTapGesture {
                        inputFocused = false
                    }

                // Input
                ChatInputBar(
                    draft: $draft,
                    onSend: sendMessage
                )
                .focused($inputFocused)
                .padding(.horizontal)
                .padding(.vertical, 8)
                .background(.ultraThinMaterial)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .navigationBar)
    }

    private func sendMessage() {
        let trimmed = draft.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        withAnimation(.easeInOut) {
            messages.append(ChatMessage(authorName: "You", text: trimmed, timestamp: Date(), isCurrentUser: true))
            draft = ""
        }
    }
}

// MARK: - Subvistas de Chat

private struct ChatMessagesList: View {
    let messages: [ChatMessage]

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: 10) {
                    ForEach(messages) { message in
                        ChatBubble(message: message)
                            .id(message.id)
                            .padding(.horizontal)
                    }
                    // Spacer al final para que el último mensaje no quede pegado
                    Color.clear.frame(height: 6)
                }
                .padding(.top, 10)
            }
            .onChange(of: messages.count) { _, _ in
                // Autoscroll al último mensaje
                if let lastID = messages.last?.id {
                    DispatchQueue.main.async {
                        withAnimation(.easeOut) {
                            proxy.scrollTo(lastID, anchor: .bottom)
                        }
                    }
                }
            }
            .onAppear {
                if let lastID = messages.last?.id {
                    proxy.scrollTo(lastID, anchor: .bottom)
                }
            }
        }
    }
}

private struct ChatBubble: View {
    let message: ChatMessage

    var body: some View {
        HStack {
            if message.isCurrentUser { Spacer(minLength: 40) }

            VStack(alignment: message.isCurrentUser ? .trailing : .leading, spacing: 4) {
                if !message.isCurrentUser {
                    Text(message.authorName)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 6)
                }

                // Estilos con mayor contraste
                let userStyle: AnyShapeStyle = AnyShapeStyle(Color.wcPurple.opacity(0.95))
                let otherStyle: AnyShapeStyle = AnyShapeStyle(Color.white.opacity(0.96))

                Text(message.text)
                    .font(.body)
                    .foregroundStyle(message.isCurrentUser ? Color.white : Color.black.opacity(0.9))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .fill(message.isCurrentUser ? userStyle : otherStyle)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .strokeBorder(
                                message.isCurrentUser ? Color.white.opacity(0.12) : Color.black.opacity(0.15),
                                lineWidth: 1
                            )
                    )
                    .shadow(color: .black.opacity(0.18), radius: 4, y: 2)

                Text(shortTime(message.timestamp))
                    .font(.caption2)
                    .foregroundStyle(message.isCurrentUser ? .white.opacity(0.8) : .secondary)
                    .padding(.horizontal, 6)
            }

            if !message.isCurrentUser { Spacer(minLength: 40) }
        }
    }

    private func shortTime(_ date: Date) -> String {
        let f = DateFormatter()
        f.dateStyle = .none
        f.timeStyle = .short
        return f.string(from: date)
    }
}

private struct ChatInputBar: View {
    @Binding var draft: String
    var onSend: () -> Void

    var body: some View {
        HStack(spacing: 8) {
            TextField("Write a message…", text: $draft, axis: .vertical)
                .textInputAutocapitalization(.sentences)
                .autocorrectionDisabled(false)
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .strokeBorder(.black.opacity(0.15), lineWidth: 1)
                )

            Button(action: onSend) {
                Image(systemName: "paperplane.fill")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.white)
                    .padding(10)
                    .background(Color.blue)
                    .clipShape(Circle())
                    .shadow(color: .black.opacity(0.2), radius: 3, y: 2)
            }
            .disabled(draft.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            .opacity(draft.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? 0.5 : 1.0)
        }
    }
}

#Preview {
    NavigationStack {
        ComunityChatView(community: CommunityLite(id: UUID(), name: "NYC Fans", emoji: "🗽"))
            .preferredColorScheme(.dark)
    }
}
