//
//  HomeCountdown.swift
//  ChristmasCountdown
//
//  Created by Андрей Чернышев on 16.10.2025.
//

import CoreLocation

final class HomeCountdown: NSObject {
    struct Countdown {
        let coordinate: CLLocationCoordinate2D
        let countdown: String
    }
    
    private lazy var locationManager = WSLocationManager()
}

// MARK: Public
extension HomeCountdown {
    func resolve(countdown: ChristmasCountdownManager.Snapshot, completion: @escaping (Countdown) -> Void) {
        locationManager.didReceiveLocation = { [weak self] coordinate in
            guard let self, let coordinate else { return }
            
            let localizedCountdown = formatHomeText(from: countdown)
            let countdown = Countdown(
                coordinate: coordinate,
                countdown: localizedCountdown
            )
            
            completion(countdown)
            
            locationManager.didReceiveLocation = nil
        }
        locationManager.requestUserLocation()
    }
}

// MARK: Private
private extension HomeCountdown {
    func formatHomeText(from snapshot: ChristmasCountdownManager.Snapshot) -> String {
        if snapshot.isChristmas {
            return "00 minutes"
        }
        
        let totalHours = snapshot.days * 24 + snapshot.hours
        
        if snapshot.days > 1 {
            return "\(snapshot.days) days, \(snapshot.hours) hours"
        }
        
        if totalHours >= 1 {
            return "\(totalHours) hours"
        }
        
        return "\(max(0, snapshot.minutes)) minutes"
    }
}
