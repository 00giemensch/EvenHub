//
//  Events.swift
//  EventsApp
//
//  Created by Никита Грицунов on 10.09.2025.
//

import UIKit
import MapKit


class Map: UIViewController {
    let iOSCoordinate = CLLocationCoordinate2D(latitude: 36.72046, longitude: 25.32879)
    let coordinateSpan = MKCoordinateSpan(latitudeDelta: 0.15, longitudeDelta: 0.15)
    
    private lazy var mapView: MKMapView = {
        let element = MKMapView()
        element.mapType = .standard

        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let region = MKCoordinateRegion(center: iOSCoordinate, span: coordinateSpan)
        mapView.delegate = self
        
        view.addSubview(mapView)
        mapView.setRegion(region, animated: true)
        setConstraints()
        
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
}

//MARK: - Extension MKMapViewDelegate

extension Map: MKMapViewDelegate {
    
}
