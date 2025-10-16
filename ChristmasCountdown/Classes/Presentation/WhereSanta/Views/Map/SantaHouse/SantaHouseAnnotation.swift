//
//  SantaHouseAnnotation.swift
//  ChristmasCountdown
//
//  Created by Андрей Чернышев on 15.10.2025.
//

import MapKit
import CoreLocation

final class SantaHouseAnnotation: NSObject, MKAnnotation {
    let coordinate: CLLocationCoordinate2D
    
    init(_ coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
        
        super.init()
    }
}
