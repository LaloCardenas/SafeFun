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

    // Número de emergencias (cámbialo por país)
    private let emergencyNumber: String = "911"

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
                    callEmergency()
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
                    .background(Color.red)
                    .clipShape(Capsule())
                    .shadow(color: .black.opacity(0.35), radius: 10, x: 0, y: 8)
                }
                .padding(.bottom, 24)
            }
            .padding(.horizontal)
        }
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

    // Llamada a emergencias
    private func callEmergency() {
        guard let url = URL(string: "tel://\(emergencyNumber)") else { return }
        UIApplication.shared.open(url)
    }
}

// MARK: - Modelos y vistas auxiliares

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
