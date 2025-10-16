//
//  SantaHouseAnnotationViewFabric.swift
//  ChristmasCountdown
//
//  Created by Андрей Чернышев on 15.10.2025.
//

import MapKit

final class SantaHouseAnnotationViewFabric {
    enum Constants {
        static let id = "santa_house_id"
    }
}

// MARK: Public
extension SantaHouseAnnotationViewFabric {
    func make(mapView: MKMapView, annotation: MKAnnotation) -> MKAnnotationView {
        let targetSize = CGSize(width: 130.scale, height: 129.scale)
        
        let image = UIImage(named: "WhereSanta.Annotation.SantaHouse")!
        
        let view = mapView.dequeueReusableAnnotationView(withIdentifier: Constants.id) ?? MKAnnotationView(annotation: annotation, reuseIdentifier: Constants.id)
        view.annotation = annotation
        view.image = resize(image: image, to: targetSize)
        view.centerOffset = CGPoint(x: 0, y: -targetSize.height / 2.0)
        return view
    }
}

// MARK: Private
private extension SantaHouseAnnotationViewFabric {
    func resize(image: UIImage, to size: CGSize) -> UIImage {
        let format = UIGraphicsImageRendererFormat()
        format.scale = UIScreen.main.scale
        
        return UIGraphicsImageRenderer(size: size, format: format).image { _ in
            image.draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
