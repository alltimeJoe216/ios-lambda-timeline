//
//  MapViewController.swift
//  ImagePostFilters
//
//  Created by Joe Veverka on 7/9/20.
//  Copyright © 2020 Joe Veverka. All rights reserved.
//

import UIKit
import MapKit
import CoreData
import CoreLocation


class MapViewController: UIViewController {
    
    var photos: [Image] = []
    var photo: Image?
    private let photoController = ImageController()
    
    @IBOutlet var mapView: MKMapView!
    
    private var userTrackingButton: MKUserTrackingButton!
    var locationManager: CLLocationManager?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userTrackingButton = MKUserTrackingButton(mapView: mapView)
        userTrackingButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(userTrackingButton)
        
        NSLayoutConstraint.activate([
            userTrackingButton.leadingAnchor.constraint(equalTo: mapView.leadingAnchor, constant: 20),
            mapView.bottomAnchor.constraint(equalTo: userTrackingButton.bottomAnchor, constant: 20)
        ])
        
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "PhotoAnnotationView")
        
        fetchPhotoLocation(photos)
    }
    
    
    func fetchPhotoLocation(_ photos: [Image]) {
        for photo in photos {
            let annotations = MKPointAnnotation()
            annotations.title = photo.title
            annotations.subtitle = "\(String(describing: photo.date))"
            annotations.coordinate = CLLocationCoordinate2D(latitude:
                photo.latitude, longitude: photo.longitude)
            mapView.addAnnotation(annotations)
        }
    }
}


