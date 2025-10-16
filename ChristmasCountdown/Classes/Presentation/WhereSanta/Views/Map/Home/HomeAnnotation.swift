//
//  HomeAnnotation.swift
//  ChristmasCountdown
//
//  Created by Андрей Чернышев on 16.10.2025.
//

import MapKit

final class HomeAnnotation: NSObject, MKAnnotation {
    let coordinate: CLLocationCoordinate2D
    let text: String

    init(coordinate: CLLocationCoordinate2D, text: String) {
        self.coordinate = coordinate
        self.text = text
        
        super.init()
    }
}
