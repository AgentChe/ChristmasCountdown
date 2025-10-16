//
//  SantaAnnotation.swift
//  ChristmasCountdown
//
//  Created by Андрей Чернышев on 15.10.2025.
//

import MapKit
import CoreLocation

 final class SantaAnnotation: NSObject, MKAnnotation {
    let coordinate: CLLocationCoordinate2D
    let place: String
    
    init(coordinate: CLLocationCoordinate2D, place: String) {
        self.coordinate = coordinate
        self.place = place
        
        super.init()
    }
}
