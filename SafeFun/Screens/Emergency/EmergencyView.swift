//
//  EmergencyView.swift
//  SafeFun
//
//  Created by Lalo Cardenas on 19/10/25.
//

import SwiftUI
import MapKit
import CoreLocation

struct EmergencyView: View {
    
    // Gestor de ubicación
    @StateObject private var locationManager = LocationManager()

    // Región por defecto (Lomas/Polanco)
    private var defaultRegion: MKCoordinateRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 19.422, longitude: -99.208),
        span: MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)
    )

    @State private var cameraPosition: MapCameraPosition
    
    @State private var hasCenteredOnUser: Bool = false
    
    // Estados para la selección y la ruta
    @State private var selectedPlace: EmergencyPlace?
    @State private var route: MKRoute?
    
    init() {
        _cameraPosition = State(initialValue: .region(defaultRegion))
    }

    private let simulatedCallNumber: String = "811"

    private let places: [EmergencyPlace] = [
        EmergencyPlace(
            name: "Punto de reunión con fans",
            coordinate: CLLocationCoordinate2D(latitude: 19.412137923774363, longitude: -99.1691600083961),
            type: .safeZone
        ),
        EmergencyPlace(
            name: "Estación de Policía (Lomas)",
            coordinate: CLLocationCoordinate2D(latitude: 19.4188, longitude: -99.2065),
            type: .police
        ),
        EmergencyPlace(
            name: "USA Embassy",
            coordinate: CLLocationCoordinate2D(latitude: 19.43299737282861, longitude: -99.16628878905449),
            type: .supportCenter
        ),
        EmergencyPlace(
            name: "Canadian Embassy",
            coordinate: CLLocationCoordinate2D(latitude: 19.43074713845559, longitude: -99.18561839223563),
            type: .supportCenter
        ),
        EmergencyPlace(
            name: "Hospital",
            coordinate: CLLocationCoordinate2D(latitude: 19.29731795246796, longitude: -99.16138535531489),
            type: .clinic
        ),
        EmergencyPlace(
            name: "Hospital",
            coordinate: CLLocationCoordinate2D(latitude: 19.416887007762636, longitude: -99.15208366685509),
            type: .hospital
        ),
        EmergencyPlace(
            name: "Estadio Banorte",
            coordinate: CLLocationCoordinate2D(latitude: 19.303175586428882, longitude: -99.15036466240505),
            type: .safeZone
        ),
        EmergencyPlace(
            name: "Departamento de policía (Centro Histórico)",
            coordinate: CLLocationCoordinate2D(latitude: 19.4330, longitude: -99.1332),
            type: .police
        ),
        EmergencyPlace(
            name: "Hospital General de México",
            coordinate: CLLocationCoordinate2D(latitude: 19.4085, longitude: -99.1550),
            type: .hospital
        ),
        EmergencyPlace(
            name: "Cenrto de apoyo a extranjeros (Coyoacán)",
            coordinate: CLLocationCoordinate2D(latitude: 19.3498, longitude: -99.1622),
            type: .supportCenter
        ),
        EmergencyPlace(
            name: "Punto de reunión con fans (Rectoría UNAM)",
            coordinate: CLLocationCoordinate2D(latitude: 19.3325, longitude: -99.1890),
            type: .safeZone
        ),
        EmergencyPlace(
            name: "Clínica (Santa Fe)",
            coordinate: CLLocationCoordinate2D(latitude: 19.3630, longitude: -99.2735),
            type: .clinic
        ),
        EmergencyPlace(
            name: "Aeropuerto T2 (Centro de apoyo a viajantes)",
            coordinate: CLLocationCoordinate2D(latitude: 19.4390, longitude: -99.0800),
            type: .supportCenter
        ),
        EmergencyPlace(
            name: "Hospital ABC (Observatorio)",
            coordinate: CLLocationCoordinate2D(latitude: 19.3975, longitude: -99.2040),
            type: .hospital
        ),
        EmergencyPlace(
            name: "Estación de policía (Polanco)",
            coordinate: CLLocationCoordinate2D(latitude: 19.4310, longitude: -99.1920),
            type: .police
        ),
        EmergencyPlace(
            name: "Clínica (Condesa)",
            coordinate: CLLocationCoordinate2D(latitude: 19.4145, longitude: -99.1685),
            type: .clinic
        )
    ]

    @State private var isTriggering: Bool = false
    @State private var showOverlay: Bool = false

    @State private var contactsStatus: EmergencyActionStatus = .pending
    @State private var nearbyUsersStatus: EmergencyActionStatus = .pending
    @State private var communitiesStatus: EmergencyActionStatus = .pending

    @State private var showSimulatorAlert: Bool = false

    var body: some View {
        ZStack {
            Map(position: $cameraPosition) {
                
                UserAnnotation()
                
                if let route {
                    MapPolyline(route.polyline)
                        .stroke(.blue.opacity(0.8), lineWidth: 6)
                }
                
                ForEach(places) { place in
                    Annotation(place.name, coordinate: place.coordinate) {
                        
                        PlaceAnnotationView(place: place)
                            .onTapGesture {
                                if place == selectedPlace {
                                    selectedPlace = nil
                                    route = nil
                                } else {
                                    selectedPlace = place
                                }
                            }
                            .scaleEffect(selectedPlace == place ? 1.2 : 1.0)
                            .shadow(radius: selectedPlace == place ? 10 : 0)
                            .animation(.spring(), value: selectedPlace)
                    }
                }
            }
            .mapStyle(.standard(elevation: .realistic))
            .ignoresSafeArea()

            VStack {
                HStack {
                    Spacer()
                    VStack(spacing: 12) {
                        
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
                            
                    }
                    .padding(.trailing, 16)
                }
                
                Spacer()

                Button {
                    Task { await triggerEmergencyFlow() }
                } label: {
                    HStack(spacing: 10) {
                        Image(systemName: "phone_fill")
                        Text("Emergencia")
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                    }
                    .font(.system(size: 20, weight: .bold))
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
            .padding(.top)

            
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

                    EmergencyActionRow(title: "Notificando a contactos de emergencia", status: contactsStatus)
                    EmergencyActionRow(title: "Alertando a usuarios cercanos", status: nearbyUsersStatus)
                    EmergencyActionRow(title: "Notificando a tus comunidades", status: communitiesStatus)

                    HStack {
                        if allDone {
                            Button {
                                openPhoneApp(number: simulatedCallNumber)
                            } label: {
                                HStack(spacing: 8) {
                                    Image(systemName: "phone.circle.fill")
                                    Text("Llamar al 911")
                                }
                                .font(.system(size: 16, weight: .semibold))
                                .padding(.horizontal, 16)
                                .padding(.vertical, 10)
                                .background(.ultraThinMaterial)
                                .clipShape(Capsule())
                            }
                        }

                        Spacer()

                        Button {
                            resetOverlay()
                        } label: {
                            Text(allDone ? "Cerrar" : "Cancelar")
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
            Text("There's no Phone app on this simulator. On a physical device, tapping “Call 911” would call \(simulatedCallNumber).")
        }
        .onAppear {
            locationManager.requestLocation()
        }
        .onChange(of: locationManager.userLocation) {
            guard let location = locationManager.userLocation, !hasCenteredOnUser else { return }
            
            let userRegion = MKCoordinateRegion(
                center: location.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            )
            
            withAnimation {
                cameraPosition = .region(userRegion)
            }
            hasCenteredOnUser = true
        }
        .onChange(of: selectedPlace) {
            if let place = selectedPlace {
                calculateRoute(to: place)
            } else {
                route = nil
            }
        }
    }

    private var allDone: Bool {
        [contactsStatus, nearbyUsersStatus, communitiesStatus].allSatisfy { $0 == .sent }
    }

    private func recenter() {
        guard let userCoordinate = locationManager.userLocation?.coordinate else {
            withAnimation {
                cameraPosition = .region(defaultRegion)
            }
            return
        }
        
        let userRegion = MKCoordinateRegion(
            center: userCoordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )
        
        withAnimation {
            cameraPosition = .region(userRegion)
        }
    }

    private func calculateRoute(to destination: EmergencyPlace) {
        
        guard locationManager.isAuthorized else {
            print("No hay permiso de ubicación para calcular la ruta.")
            selectedPlace = nil
            return
        }
        
        guard let userCoordinate = locationManager.userLocation?.coordinate else {
            print("No se ha podido obtener la ubicación actual.")
            selectedPlace = nil
            return
        }
        
        route = nil

        // puntos de inicio y fin
        let sourceItem = MKMapItem(placemark: MKPlacemark(coordinate: userCoordinate))
        let destItem = MKMapItem(placemark: MKPlacemark(coordinate: destination.coordinate))

        let request = MKDirections.Request()
        request.source = sourceItem
        request.destination = destItem
        request.transportType = .automobile
        
        let directions = MKDirections(request: request)
        directions.calculate { response, error in
            if let error = error {
                print("Error al calcular la ruta: \(error.localizedDescription)")
                return
            }
            
            if let firstRoute = response?.routes.first {
                self.route = firstRoute
            }
        }
    }


    private func triggerEmergencyFlow() async {
        isTriggering = true
        showOverlay = true

        contactsStatus = .sending
        try? await Task.sleep(nanoseconds: 800_000_000)
        contactsStatus = .sent

        nearbyUsersStatus = .sending
        try? await Task.sleep(nanoseconds: 800_000_000)
        nearbyUsersStatus = .sent

        communitiesStatus = .sending
        try? await Task.sleep(nanoseconds: 800_000_000)
        communitiesStatus = .sent

        isTriggering = false
    }

    private func openPhoneApp(number: String) {
        #if targetEnvironment(simulator)
        showSimulatorAlert = true
        #else
        guard let url = URL(string: "tel://\(number)") else { return }
        UIApplication.shared.open(url)
        #endif
    }

    private func resetOverlay() {
        withAnimation {
            showOverlay = false
        }
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
            case .pending: return "Pendiente"
            case .sending: return "Enviando…"
            case .sent:    return "Enviado"
            case .failed:  return "Falló"
            }
        }())
        .font(.caption)
        .foregroundStyle(.secondary)
    }
}

private struct EmergencyPlace: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
    let type: PlaceType
    
    static func == (lhs: EmergencyPlace, rhs: EmergencyPlace) -> Bool {
        lhs.id == rhs.id
    }
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
