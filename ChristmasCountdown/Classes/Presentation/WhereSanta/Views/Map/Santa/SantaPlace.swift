//
//  SantaPlace.swift
//  ChristmasCountdown
//
//  Created by Андрей Чернышев on 15.10.2025.
//

import CoreLocation

final class SantaPlace: NSObject {
    struct Place {
        let name: String
        let coordinate: CLLocationCoordinate2D
    }
    
    private lazy var locationManager = WSLocationManager()
}

// MARK: Public
extension SantaPlace {
    func resolve(for date: Date, completion: @escaping (Place?) -> Void) {
        let calendar = Calendar(identifier: .gregorian)
        
        let comps = calendar.dateComponents([.year, .month, .day], from: date)
        
        guard
            let month = comps.month,
            let day = comps.day,
            let daysRange = calendar.range(of: .day, in: .month, for: date)
        else {
            completion(nil)
            return
        }
        
        if month == 12 && day == 25 {
            locationManager.didReceiveLocation = { [weak self] location in
                guard let self, let location else { return }
                
                let place = Place(name: "Your area", coordinate: location)
                completion(place)
                
                locationManager.didReceiveLocation = nil
            }
            locationManager.requestUserLocation()
            
            return
        }
        
        if month == 12 && day >= 26 {
            let place = Place(name: "North Pole", coordinate: CLLocationCoordinate2D(latitude: 82.6336, longitude: 0.268))
            completion(place)
            
            return
        }

        let daysInMonth = daysRange.count
        let fraction = Double(day - 1) / Double(daysInMonth)

        let place: Place = {
            switch month {
            case 1:
                return Place(name: "North Pole", coordinate: CLLocationCoordinate2D(latitude: 82.6336, longitude: 0.268))
            case 2:
                return fraction < 0.5
                ? Place(name: "Yukon", coordinate: CLLocationCoordinate2D(latitude: 60.7212, longitude: -135.0568))
                : Place(name: "Banff", coordinate: CLLocationCoordinate2D(latitude: 51.1784, longitude: -115.5708))

            case 3:
                if fraction < 1.0/3.0 {
                    return Place(name: "Quebec", coordinate: CLLocationCoordinate2D(latitude: 46.8139, longitude: -71.2080))
                } else if fraction < 2.0/3.0 {
                    return Place(name: "Alaska", coordinate: CLLocationCoordinate2D(latitude: 61.2181, longitude: -149.9003))
                } else {
                    return Place(name: "Seattle", coordinate: CLLocationCoordinate2D(latitude: 47.6062, longitude: -122.3321))
                }

            case 4:
                if fraction < 1.0/3.0 {
                    return Place(name: "San Francisco", coordinate: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194))
                } else if fraction < 2.0/3.0 {
                    return Place(name: "Sapporo", coordinate: CLLocationCoordinate2D(latitude: 43.0618, longitude: 141.3545))
                } else {
                    return Place(name: "Tokyo", coordinate: CLLocationCoordinate2D(latitude: 35.6762, longitude: 139.6503))
                }

            case 5:
                if fraction < 1.0/3.0 {
                    return Place(name: "Kyoto", coordinate: CLLocationCoordinate2D(latitude: 35.0116, longitude: 135.7681))
                } else if fraction < 2.0/3.0 {
                    return Place(name: "Venice", coordinate: CLLocationCoordinate2D(latitude: 45.4408, longitude: 12.3155))
                } else {
                    return Place(name: "Paris", coordinate: CLLocationCoordinate2D(latitude: 48.8566, longitude: 2.3522))
                }

            case 6:
                if fraction < 1.0/3.0 {
                    return Place(name: "Vienna", coordinate: CLLocationCoordinate2D(latitude: 48.2082, longitude: 16.3738))
                } else if fraction < 2.0/3.0 {
                    return Place(name: "Prague", coordinate: CLLocationCoordinate2D(latitude: 50.0755, longitude: 14.4378))
                } else {
                    return Place(name: "Nairobi", coordinate: CLLocationCoordinate2D(latitude: -1.2921, longitude: 36.8219))
                }

            case 7:
                if fraction < 0.25 {
                    return Place(name: "Kilimanjaro", coordinate: CLLocationCoordinate2D(latitude: -3.0674, longitude: 37.3556))
                } else if fraction < 0.50 {
                    return Place(name: "Cape Town", coordinate: CLLocationCoordinate2D(latitude: -33.9249, longitude: 18.4241))
                } else if fraction < 0.75 {
                    return Place(name: "Sydney", coordinate: CLLocationCoordinate2D(latitude: -33.8688, longitude: 151.2093))
                } else {
                    return Place(name: "Auckland", coordinate: CLLocationCoordinate2D(latitude: -36.8509, longitude: 174.7645))
                }

            case 8:
                if fraction < 1.0/3.0 {
                    return Place(name: "Queenstown", coordinate: CLLocationCoordinate2D(latitude: -45.0312, longitude: 168.6626))
                } else if fraction < 2.0/3.0 {
                    return Place(name: "Bangkok", coordinate: CLLocationCoordinate2D(latitude: 13.7563, longitude: 100.5018))
                } else {
                    return Place(name: "Singapore", coordinate: CLLocationCoordinate2D(latitude: 1.3521, longitude: 103.8198))
                }

            case 9:
                if fraction < 1.0/3.0 {
                    return Place(name: "Bali", coordinate: CLLocationCoordinate2D(latitude: -8.6500, longitude: 115.2167))
                } else if fraction < 2.0/3.0 {
                    return Place(name: "Rio", coordinate: CLLocationCoordinate2D(latitude: -22.9068, longitude: -43.1729))
                } else {
                    return Place(name: "Buenos Aires", coordinate: CLLocationCoordinate2D(latitude: -34.6037, longitude: -58.3816))
                }

            case 10:
                if fraction < 1.0/3.0 {
                    return Place(name: "Machu Picchu", coordinate: CLLocationCoordinate2D(latitude: -13.1631, longitude: -72.5450))
                } else if fraction < 2.0/3.0 {
                    return Place(name: "New York", coordinate: CLLocationCoordinate2D(latitude: 40.7128, longitude: -74.0060))
                } else {
                    return Place(name: "Chicago", coordinate: CLLocationCoordinate2D(latitude: 41.8781, longitude: -87.6298))
                }

            case 11:
                return fraction < 0.5
                ? Place(name: "Los Angeles", coordinate: CLLocationCoordinate2D(latitude: 34.0522, longitude: -118.2437))
                : Place(name: "Beijing", coordinate: CLLocationCoordinate2D(latitude: 39.9042, longitude: 116.4074))

            case 12:
                return fraction < 0.5
                ? Place(name: "Seoul", coordinate: CLLocationCoordinate2D(latitude: 37.5665, longitude: 126.9780))
                : Place(name: "Vladivostok", coordinate: CLLocationCoordinate2D(latitude: 43.1155, longitude: 131.8855))

            default:
                return Place(name: "North Pole", coordinate: CLLocationCoordinate2D(latitude: 82.6336, longitude: 0.268))
            }
        }()
        completion(place)
    }
}
