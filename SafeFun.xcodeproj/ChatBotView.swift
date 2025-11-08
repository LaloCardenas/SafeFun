//  ChatBotView.swift
//  SafeFun
//
//  Created by Assistant on 06/11/25.
//
//  Pantalla de chat con integración real a Foundation Models (Apple Intelligence)

import SwiftUI
import FoundationModels

struct ChatMessage: Identifiable {
    let id = UUID()
    let text: String
    let isUser: Bool
}

struct ChatBotView: View {
    @State private var messages: [ChatMessage] = []
    @State private var inputText: String = ""
    @State private var isResponding = false
    @State private var modelAvailability: SystemLanguageModel.Availability = SystemLanguageModel.default.availability
    @State private var errorMessage: String? = nil
    
    // Preparamos instrucciones para el modelo
    private let instructions = """
    Eres un asistente útil que responde de manera clara, amigable y breve. Si no sabes la respuesta, responde con sinceridad. Responde solo en español si el usuario escribe en español.
    """
    
    // Manten una sola sesión para el historial del chat
    @State private var session: LanguageModelSession? = nil
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Mensajes del chat
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(alignment: .leading, spacing: 12) {
                            ForEach(messages) { msg in
                                HStack {
                                    if msg.isUser { Spacer() }
                                    Text(msg.text)
                                        .padding(10)
                                        .foregroundStyle(msg.isUser ? .white : .primary)
                                        .background(msg.isUser ? Color.wcPurple : Color(.systemGray6))
                                        .cornerRadius(12)
                                        .frame(maxWidth: 260, alignment: msg.isUser ? .trailing : .leading)
                                    if !msg.isUser { Spacer() }
                                }
                                .id(msg.id)
                            }
                            if isResponding {
                                HStack {
                                    Spacer()
                                    ProgressView()
                                        .padding(10)
                                        .background(Color(.systemGray6))
                                        .cornerRadius(12)
                                }
                            }
                        }
                        .padding(.vertical, 20)
                    }
                    .background(BackgroundView())
                    .onChange(of: messages.count) { _, _ in
                        withAnimation {
                            if let last = messages.last?.id {
                                proxy.scrollTo(last, anchor: .bottom)
                            }
                        }
                    }
                }
                Divider()
                // Input + botón
                HStack(spacing: 10) {
                    TextField("Escribe tu mensaje...", text: $inputText, axis: .vertical)
                        .textFieldStyle(.roundedBorder)
                        .disabled(isResponding || !isModelAvailable)
                        .lineLimit(1...4)
                    Button {
                        sendMessage()
                    } label: {
                        Image(systemName: "paperplane.fill")
                            .font(.title2)
                    }
                    .disabled(inputText.trimmed.isEmpty || isResponding || !isModelAvailable)
                }
                .padding(.horizontal)
                .padding(.vertical, 10)
            }
            .navigationTitle("ChatBot (AI)")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cerrar") {
                        // Dismiss: el padre puede usar .sheet o NavigationLink
                    }
                }
            }
            .onAppear {
                modelAvailability = SystemLanguageModel.default.availability
                if modelAvailability == .available {
                    session = LanguageModelSession(instructions: instructions)
                }
            }
            .alert(item: $errorMessage) { msg in
                Alert(title: Text("Error"), message: Text(msg), dismissButton: .default(Text("OK")))
            }
            .overlay(
                Group {
                    if !isModelAvailable {
                        VStack {
                            Spacer()
                            Text(modelAvailabilityMessage)
                                .font(.callout.bold())
                                .padding(18)
                                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 18))
                                .padding(30)
                            Spacer()
                        }
                        .background(Color.black.opacity(0.15))
                    }
                }
            )
        }
    }
    
    // --- Helpers ---
    private var isModelAvailable: Bool {
        if case .available = modelAvailability { return true }
        return false
    }
    
    private var modelAvailabilityMessage: String {
        switch modelAvailability {
        case .available:
            return ""
        case .unavailable(.deviceNotEligible):
            return "Este dispositivo no es compatible con Apple Intelligence."
        case .unavailable(.appleIntelligenceNotEnabled):
            return "Activa Apple Intelligence en Ajustes para usar el chat."
        case .unavailable(.modelNotReady):
            return "El modelo de lenguaje está descargando o no está listo. Intenta más tarde."
        case .unavailable(let other):
            return "Modelo no disponible: \(other)"
        }
    }
    
    private func sendMessage() {
        guard !inputText.trimmed.isEmpty, let session else { return }
        let userMessage = inputText.trimmed
        messages.append(ChatMessage(text: userMessage, isUser: true))
        inputText = ""
        isResponding = true
        Task {
            do {
                let response = try await session.respond(to: userMessage)
                messages.append(ChatMessage(text: response.content, isUser: false))
            } catch {
                errorMessage = error.localizedDescription
            }
            isResponding = false
        }
    }
}

private extension String {
    var trimmed: String {
        self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

#Preview {
    ChatBotView()
}
