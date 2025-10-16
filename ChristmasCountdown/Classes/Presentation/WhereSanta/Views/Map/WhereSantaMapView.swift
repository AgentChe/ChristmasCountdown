//
//  WhereSantaMapView.swift
//  ChristmasCountdown
//
//  Created by Андрей Чернышев on 12.10.2025.
//

import UIKit
import MapKit

final class WhereSantaMapView: UIView {
    lazy var mapView = makeMapView()
    
    private lazy var santaPlace = SantaPlace()
    private lazy var homeCountdown = HomeCountdown()
    
    private lazy var santaHouseAnnotationViewFabric = SantaHouseAnnotationViewFabric()
    private lazy var santaAnnotationViewFabric = SantaAnnotationViewFabric()
    private lazy var homeAnnotationViewFabric = HomeAnnotationViewFabric()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension WhereSantaMapView {
    func showSantaHouse() {
        mapView.removeAnnotations(mapView.annotations)

        let coord = CLLocationCoordinate2D(latitude: 82.6336, longitude: 0.268)

        guard CLLocationCoordinate2DIsValid(coord) else { return }

        mapView.addAnnotation(SantaHouseAnnotation(coord))
        
        let camera = MKMapCamera(lookingAtCenter: coord, fromDistance: 2_360_000, pitch: 0, heading: 0)
        mapView.setCamera(camera, animated: true)
    }
    
    func showSanta() {
        mapView.removeAnnotations(mapView.annotations)
        
        santaPlace.resolve(for: Date()) { [weak self] place in
            guard let self, let place else { return }
            
            let annotation = SantaAnnotation(coordinate: place.coordinate, place: place.name)
            mapView.addAnnotation(annotation)
            
            let camera = MKMapCamera(lookingAtCenter: place.coordinate, fromDistance: 3_360_000, pitch: 0, heading: 0)
            mapView.setCamera(camera, animated: true)
        }
    }
    
    func showHome(countdown: ChristmasCountdownManager.Snapshot) {
        mapView.removeAnnotations(mapView.annotations)
        
        homeCountdown.resolve(countdown: countdown) { [weak self] countdown in
            guard let self else { return }
            
            let annotation = HomeAnnotation(coordinate: countdown.coordinate, text: countdown.countdown)
            mapView.addAnnotation(annotation)
            
            let camera = MKMapCamera(lookingAtCenter: countdown.coordinate, fromDistance: 3_360_000, pitch: 0, heading: 0)
            mapView.setCamera(camera, animated: true)
        }
    }
}

// MARK: MKMapViewDelegate
extension WhereSantaMapView: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is SantaHouseAnnotation {
            return santaHouseAnnotationViewFabric.make(mapView: mapView, annotation: annotation)
        } else if let santaAnnotation = annotation as? SantaAnnotation {
            return santaAnnotationViewFabric.make(mapView: mapView, annotation: santaAnnotation)
        } else if let homeAnnotation = annotation as? HomeAnnotation {
            return homeAnnotationViewFabric.make(mapView: mapView, annotation: homeAnnotation)
        }
        
        return nil
    }
}

// MARK: Private
private extension WhereSantaMapView {
    func initialize() {
        backgroundColor = UIColor.clear
    }
}

// MARK: Make constraints
private extension WhereSantaMapView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            mapView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: trailingAnchor),
            mapView.topAnchor.constraint(equalTo: topAnchor),
            mapView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension WhereSantaMapView {
    func makeMapView() -> MKMapView {
        let view = MKMapView()
        view.overrideUserInterfaceStyle = .light
        view.mapType = .mutedStandard
        view.showsUserLocation = false
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
