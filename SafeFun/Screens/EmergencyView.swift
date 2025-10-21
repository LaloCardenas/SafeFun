//
//  EmergencyView.swift
//  SafeFun
//
//  Created by Lalo Cardenas on 19/10/25.
//

import SwiftUI
import MapKit

struct EmergencyView: View {
    // Región inicial (CDMX como ejemplo)
    @State private var cameraPosition: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 19.432608, longitude: -99.133209),
            span: MKCoordinateSpan(latitudeDelta: 0.12, longitudeDelta: 0.12)
        )
    )

    // Número de emergencias (placeholder para “simular” la llamada al final)
    // Puedes cambiarlo por uno inexistente para pruebas.
    private let simulatedCallNumber: String = "911"

    // Puntos de interés hardcoded
    private let places: [EmergencyPlace] = [
        EmergencyPlace(
            name: "Hospital General",
            coordinate: CLLocationCoordinate2D(latitude: 19.4273, longitude: -99.1546),
            type: .hospital
        ),
        EmergencyPlace(
            name: "Clínica de Atención",
            coordinate: CLLocationCoordinate2D(latitude: 19.4405, longitude: -99.1350),
            type: .clinic
        ),
        EmergencyPlace(
            name: "Oficina de Policía",
            coordinate: CLLocationCoordinate2D(latitude: 19.4280, longitude: -99.1210),
            type: .police
        ),
        EmergencyPlace(
            name: "Zona Segura",
            coordinate: CLLocationCoordinate2D(latitude: 19.4202, longitude: -99.1337),
            type: .safeZone
        ),
        EmergencyPlace(
            name: "Centro de Apoyo a Extranjeros",
            coordinate: CLLocationCoordinate2D(latitude: 19.4370, longitude: -99.1450),
            type: .supportCenter
        )
    ]

    // Estados de simulación
    @State private var isTriggering: Bool = false
    @State private var showOverlay: Bool = false

    @State private var callStatus: EmergencyActionStatus = .pending
    @State private var contactsStatus: EmergencyActionStatus = .pending
    @State private var nearbyUsersStatus: EmergencyActionStatus = .pending
    @State private var communitiesStatus: EmergencyActionStatus = .pending

    // Alert para simulador
    @State private var showSimulatorAlert: Bool = false

    var body: some View {
        ZStack {
            // 1) Mapa como fondo
            Map(position: $cameraPosition) {
                ForEach(places) { place in
                    Annotation(place.name, coordinate: place.coordinate) {
                        PlaceAnnotationView(place: place)
                    }
                }
            }
            .mapStyle(.standard(elevation: .realistic))
            .ignoresSafeArea()

            // 2) Controles flotantes
            VStack {
                // Botón de recenter arriba a la derecha
                HStack {
                    Spacer()
                    Button {
                        recenter()
                    } label: {
                        Image(systemName: "location.circle.fill")
                            .font(.system(size: 28))
                            .foregroundStyle(.white)
                            .padding(10)
                            .background(.black.opacity(0.35))
                            .clipShape(Circle())
                    }
                    .padding(.trailing, 16)
                    .padding(.top, 16)
                }
                Spacer()

                // Botón de emergencia grande
                Button {
                    Task { await triggerEmergencyFlow() }
                } label: {
                    HStack(spacing: 10) {
                        Image(systemName: "phone.fill")
                            .font(.system(size: 20, weight: .bold))
                        Text("Emergency")
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                    }
                    .foregroundStyle(.white)
                    .padding(.horizontal, 22)
                    .padding(.vertical, 14)
                    .background(isTriggering ? Color.red.opacity(0.6) : Color.red)
                    .clipShape(Capsule())
                    .shadow(color: .black.opacity(0.35), radius: 10, x: 0, y: 8)
                }
                .disabled(isTriggering)
                .padding(.bottom, 24)
            }
            .padding(.horizontal)

            // 3) Overlay de simulación
            if showOverlay {
                Color.black.opacity(0.35)
                    .ignoresSafeArea()
                    .transition(.opacity)

                VStack(spacing: 14) {
                    HStack(spacing: 10) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundStyle(.yellow)
                        Text("Emergency in progress")
                            .font(.headline)
                        Spacer()
                    }

                    // Mostramos en orden: contactos, cercanos, comunidades y finalmente llamada
                    EmergencyActionRow(title: "Notifying trusted contacts", status: contactsStatus)
                    EmergencyActionRow(title: "Alerting nearby users", status: nearbyUsersStatus)
                    EmergencyActionRow(title: "Notifying your communities", status: communitiesStatus)
                    EmergencyActionRow(title: "Opening Phone app to call", status: callStatus)

                    HStack {
                        Spacer()
                        Button {
                            resetOverlay()
                        } label: {
                            Text(allDone ? "Close" : "Cancel")
                                .font(.system(size: 16, weight: .semibold))
                                .padding(.horizontal, 16)
                                .padding(.vertical, 10)
                                .background(.ultraThinMaterial)
                                .clipShape(Capsule())
                        }
                    }
                    .padding(.top, 6)
                }
                .padding(16)
                .frame(maxWidth: 500)
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                .padding(.horizontal, 20)
                .transition(.scale)
            }
        }
        .alert("Call Simulation", isPresented: $showSimulatorAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("There's no Phone app on this simulator. In a physical device, it would call \(simulatedCallNumber).")
        }
    }

    private var allDone: Bool {
        [callStatus, contactsStatus, nearbyUsersStatus, communitiesStatus].allSatisfy { $0 == .sent }
    }

    // Recentrar la cámara a la región inicial
    private func recenter() {
        withAnimation {
            cameraPosition = .region(
                MKCoordinateRegion(
                    center: CLLocationCoordinate2D(latitude: 19.432608, longitude: -99.133209),
                    span: MKCoordinateSpan(latitudeDelta: 0.12, longitudeDelta: 0.12)
                )
            )
        }
    }

    // Flujo simulado de emergencia
    private func triggerEmergencyFlow() async {
        isTriggering = true
        showOverlay = true

        // 1) Notificar contactos
        contactsStatus = .sending
        try? await Task.sleep(nanoseconds: 800_000_000)
        contactsStatus = .sent

        // 2) Notificar usuarios cercanos
        nearbyUsersStatus = .sending
        try? await Task.sleep(nanoseconds: 800_000_000)
        nearbyUsersStatus = .sent

        // 3) Notificar comunidades
        communitiesStatus = .sending
        try? await Task.sleep(nanoseconds: 800_000_000)
        communitiesStatus = .sent

        // 4) Al final, abrir Teléfono y “simular” llamada
        callStatus = .sending
        openPhoneAppSimulated(number: simulatedCallNumber)
        // Pequeño delay para marcar como “enviado”
        try? await Task.sleep(nanoseconds: 600_000_000)
        callStatus = .sent

        isTriggering = false
    }

    // Abrir app Teléfono con un número ficticio
    private func openPhoneAppSimulated(number: String) {
        #if targetEnvironment(simulator)
        // En simulador: mostrar un Alert en lugar de abrir Teléfono
        showSimulatorAlert = true
        #else
        // En dispositivo: abrir Teléfono
        guard let url = URL(string: "tel://\(number)") else { return }
        UIApplication.shared.open(url)
        #endif
    }

    private func resetOverlay() {
        withAnimation {
            showOverlay = false
        }
        callStatus = .pending
        contactsStatus = .pending
        nearbyUsersStatus = .pending
        communitiesStatus = .pending
        isTriggering = false
    }
}

// MARK: - Modelos y vistas auxiliares

private enum EmergencyActionStatus: Equatable {
    case pending
    case sending
    case sent
    case failed
}

private struct EmergencyActionRow: View {
    let title: String
    let status: EmergencyActionStatus

    var body: some View {
        HStack(spacing: 10) {
            statusIcon
            Text(title)
                .font(.subheadline)
            Spacer()
            statusLabel
        }
        .padding(10)
        .background(Color.white.opacity(0.06))
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
    }

    private var statusIcon: some View {
        Group {
            switch status {
            case .pending:
                Image(systemName: "clock")
                    .foregroundStyle(.secondary)
            case .sending:
                ProgressView()
                    .progressViewStyle(.circular)
            case .sent:
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(.green)
            case .failed:
                Image(systemName: "xmark.octagon.fill")
                    .foregroundStyle(.red)
            }
        }
        .frame(width: 20, height: 20)
    }

    private var statusLabel: some View {
        Text({
            switch status {
            case .pending: return "Pending"
            case .sending: return "Sending…"
            case .sent:    return "Sent"
            case .failed:  return "Failed"
            }
        }())
        .font(.caption)
        .foregroundStyle(.secondary)
    }
}

private struct EmergencyPlace: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
    let type: PlaceType
}

private enum PlaceType {
    case hospital
    case clinic
    case police
    case safeZone
    case supportCenter

    var symbolName: String {
        switch self {
        case .hospital: return "cross.case.fill"
        case .clinic: return "stethoscope"
        case .police: return "shield.lefthalf.filled"
        case .safeZone: return "checkmark.shield.fill"
        case .supportCenter: return "person.2.fill"
        }
    }

    var tint: Color {
        switch self {
        case .hospital: return .red
        case .clinic: return .pink
        case .police: return .blue
        case .safeZone: return .green
        case .supportCenter: return .purple
        }
    }
}

private struct PlaceAnnotationView: View {
    let place: EmergencyPlace

    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: place.type.symbolName)
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(.white)
                .padding(10)
                .background(place.type.tint)
                .clipShape(Circle())
                .shadow(color: .black.opacity(0.25), radius: 6, x: 0, y: 4)

            Text(place.name)
                .font(.caption2)
                .bold()
                .padding(.horizontal, 6)
                .padding(.vertical, 3)
                .background(.ultraThinMaterial)
                .clipShape(Capsule())
        }
    }
}

#Preview {
    EmergencyView()
}
