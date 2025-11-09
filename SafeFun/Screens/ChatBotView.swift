//  ChatBotView.swift
//  SafeFun
//
//  Created by Assistant on 06/11/25.
//
//  Pantalla de chat con integración real a Foundation Models (Apple Intelligence)

import SwiftUI
import FoundationModels

struct BotMessage: Identifiable {
    let id = UUID()
    let text: String
    let isUser: Bool
}

struct ChatBotView: View {
    @State private var messages: [BotMessage] = .init()
    @State private var inputText: String = ""
    @State private var isResponding = false
    @State private var modelAvailability: SystemLanguageModel.Availability = SystemLanguageModel.default.availability
    @State private var errorMessage: String = ""
    @State private var showErrorAlert: Bool = false
    
    // Preparamos instrucciones para el modelo
    private let instructions = """
    Eres un asistente útil que responde de manera clara, amigable y breve. Si no sabes la respuesta, responde con sinceridad. Responde solo en español si el usuario escribe en español. Cuando se te proporcione CONTEXTO ACTUALIZADO úsalo como fuente principal y cítalo explícitamente si corresponde. Si el contexto no cubre la pregunta, indícalo y ofrece pasos o enlaces oficiales.
    """
    
    // Manten una sola sesión para el historial del chat
    @State private var session: LanguageModelSession? = nil
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                messagesList
                Divider()
                inputBar
            }
            .navigationTitle("SafeFunAI")
            .onAppear {
                modelAvailability = SystemLanguageModel.default.availability
                if modelAvailability == .available {
                    session = LanguageModelSession(instructions: instructions)
                }
            }
            .overlay(modelUnavailableOverlay)
            .alert("Error", isPresented: $showErrorAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
        }
    }
    
    private var messagesList: some View {
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
                            TypingDotsView()
                                .padding(10)
                                .background(Color(.systemGray6))
                                .cornerRadius(12)
                                .frame(maxWidth: 260, alignment: .leading)
                            Spacer()
                        }
                    }
                }
                .padding(.vertical, 20)
                .padding(.horizontal, 12)
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
    }
    
    private var inputBar: some View {
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
            .disabled(inputText.botTrimmed.isEmpty || isResponding || !isModelAvailable)
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
    }
    
    private var modelUnavailableOverlay: some View {
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
    }
    
    
    // Nueva función para crear contexto actualizado
    private func buildUpdatedContext(for userQuery: String) async -> String {
        // TODO: Reemplazar este stub con consultas reales a tus APIs/BD/feeds.
        // Heurística simple: si la consulta menciona mundial, sedes, estadios, turismo o ayuda, incluimos contexto de Mundial 2026.
        let q = userQuery.lowercased()
        var snippets: [String] = []

        // Núcleo del contexto del Mundial 2026 (resumen curado). Ajusta/expande según tus fuentes.
        let worldCupCore = """
        Mundial 2026 (FIFA World Cup 2026): Se celebrará en Canadá, Estados Unidos y México. Ciudades/estadios sede destacados (lista no exhaustiva):
        - México: CDMX (Estadio Azteca), Guadalajara (Estadio Akron), Monterrey (Estadio BBVA).
        - Estados Unidos: Atlanta (Mercedes-Benz Stadium), Boston/Foxborough (Gillette Stadium), Dallas/Arlington (AT&T Stadium), Houston (NRG Stadium), Kansas City (GEHA Field at Arrowhead Stadium), Los Ángeles/Inglewood (SoFi Stadium), Miami (Hard Rock Stadium), Nueva York/Nueva Jersey (MetLife Stadium), Filadelfia (Lincoln Financial Field), San Francisco/Santa Clara (Levi's Stadium), Seattle (Lumen Field).
        - Canadá: Toronto (BMO Field), Vancouver (BC Place).

        Lugares turísticos cercanos (ejemplos):
        - CDMX: Centro Histórico, Coyoacán, Xochimilco, Museo Frida Kahlo.
        - Guadalajara: Centro Histórico, Tlaquepaque, Tequila (pueblo mágico cercano).
        - Monterrey: Parque Fundidora, Macroplaza, Parque Chipinque.
        - Vancouver: Stanley Park, Granville Island, Capilano Suspension Bridge.
        - Toronto: CN Tower, Distillery District, Royal Ontario Museum.
        - Seattle: Pike Place Market, Space Needle, Chihuly Garden and Glass.
        - Los Ángeles: Santa Monica, Griffith Observatory, Hollywood.

        Centros y líneas de apoyo (verifica localmente/actualiza con fuentes oficiales):
        - Emergencias: 911 (EE. UU. y México), 911/112 (Canadá).
        - Información turística: oficinas locales de turismo en cada ciudad sede.
        - Asistencia consular: contactar el consulado/embajada del país del visitante.

        Consejos de transporte y acceso: revisa apps locales (metrobus, metro, transit), rideshare, y avisos de cierres viales en días de partido.
        """

        if q.contains("mundial") || q.contains("world cup") || q.contains("2026") || q.contains("estadio") || q.contains("estadios") || q.contains("sede") || q.contains("sedes") || q.contains("turismo") || q.contains("turísticos") || q.contains("apoyo") || q.contains("centros") {
            snippets.append(worldCupCore)
        }

        // Puedes agregar aquí más fuentes dinámicas: resultados de API, documentos locales, etc.
        // Por ejemplo: resultados de una búsqueda por ciudad detectada en la consulta.

        guard !snippets.isEmpty else { return "" }

        let header = """
        CONTEXTO ACTUALIZADO (resumen):
        - Usa este contexto como fuente principal para responder.
        - Si algo no está en el contexto, indícalo y sugiere fuentes oficiales.
        """

        return ([header] + snippets).joined(separator: "\n\n")
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
        guard !inputText.botTrimmed.isEmpty, let session else { return }
        let userMessage = inputText.botTrimmed
        messages.append(BotMessage(text: userMessage, isUser: true))
        inputText = ""
        isResponding = true
        Task {
            do {
                let context = await buildUpdatedContext(for: userMessage)
                let fullPrompt: String
                if context.isEmpty {
                    fullPrompt = userMessage
                } else {
                    fullPrompt = "\(context)\n\nPREGUNTA DEL USUARIO: \(userMessage)"
                }
                let response = try await session.respond(to: fullPrompt)
                messages.append(BotMessage(text: response.content, isUser: false))
                if !context.isEmpty {
                    messages.append(BotMessage(text: "(Se usó contexto actualizado del Mundial 2026)", isUser: false))
                }
            } catch {
                errorMessage = error.localizedDescription
                showErrorAlert = true
            }
            isResponding = false
        }
    }
}

private extension String {
    var botTrimmed: String {
        self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

private struct TypingDotsView: View {
    @State private var phase: Int = 0
    @State private var timer: Timer? = nil

    var body: some View {
        HStack(spacing: 6) {
            Circle().fill(Color.primary.opacity(0.6)).frame(width: 6, height: 6)
                .opacity(phase == 0 ? 1 : 0.3)
            Circle().fill(Color.primary.opacity(0.6)).frame(width: 6, height: 6)
                .opacity(phase == 1 ? 1 : 0.3)
            Circle().fill(Color.primary.opacity(0.6)).frame(width: 6, height: 6)
                .opacity(phase == 2 ? 1 : 0.3)
        }
        .onAppear {
            timer?.invalidate()
            timer = Timer.scheduledTimer(withTimeInterval: 0.35, repeats: true) { _ in
                withAnimation(.easeInOut(duration: 0.25)) {
                    phase = (phase + 1) % 3
                }
            }
        }
        .onDisappear {
            timer?.invalidate()
            timer = nil
        }
        .accessibilityLabel("Escribiendo…")
    }
}

#Preview {
    ChatBotView()
}
