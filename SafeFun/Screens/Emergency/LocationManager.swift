//
//  LocationManager.swift
//  SafeFun
//
//  Created by Lalo Cardenas on 19/10/25.
//

import Foundation
import CoreLocation
internal import Combine

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    private let manager = CLLocationManager()
    
    @Published var userLocation: CLLocation?
    @Published var isAuthorized: Bool = false

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest 
    }
    
    func requestLocation() {
        manager.requestWhenInUseAuthorization()
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            isAuthorized = true
            manager.startUpdatingLocation()
        
        case .denied, .restricted:
            isAuthorized = false
            manager.stopUpdatingLocation()
            
        case .notDetermined:
            isAuthorized = false
            
        @unknown default:
            break
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        userLocation = locations.last
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error al obtener la ubicación: \(error.localizedDescription)")
    }
}
