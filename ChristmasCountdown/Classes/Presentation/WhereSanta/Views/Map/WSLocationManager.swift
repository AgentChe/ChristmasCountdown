//
//  WSLocationManager.swift
//  ChristmasCountdown
//
//  Created by Андрей Чернышев on 15.10.2025.
//

import CoreLocation

final class WSLocationManager: NSObject {
    enum Constants {
        static let staleInterval: TimeInterval = 86400
    }
    
    var didReceiveLocation: ((CLLocationCoordinate2D?) -> Void)?
    
    private lazy var locationManager = CLLocationManager()
    
    private var lastCoordinate: CLLocationCoordinate2D?
    
    override init() {
        super.init()
        
        locationManager.delegate = self
    }
}

// MARK: Public
extension WSLocationManager {
    func requestUserLocation() {
        if let lastCoordinate {
            didReceiveLocation?(lastCoordinate)
            return
        }
        
        if let loc = locationManager.location, Date().timeIntervalSince(loc.timestamp) < Constants.staleInterval {
            lastCoordinate = loc.coordinate
            didReceiveLocation?(loc.coordinate)
            return
        }
        
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.requestLocation()
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .denied, .restricted:
            didReceiveLocation?(nil)
        @unknown default:
            break
        }
    }
}

// MARK: CLLocationManagerDelegate
extension WSLocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            manager.requestLocation()
        } else {
            didReceiveLocation?(nil)
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        lastCoordinate = locations.last?.coordinate
        
        didReceiveLocation?(lastCoordinate)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) { }
}
