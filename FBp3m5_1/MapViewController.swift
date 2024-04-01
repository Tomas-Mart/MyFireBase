//
//  MapViewController.swift
//  FBp3m5_1
//
//  Created by Amina TomasMart on 28.03.2024.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    private let service = Service()
    
    private var location: CLLocation?
    
    private lazy var map: MKMapView = {
        $0.frame = view.frame
        return $0
    }(MKMapView())
    
    private lazy var button: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.heightAnchor.constraint(equalToConstant: 50).isActive = true
        $0.setTitle("Save", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .systemMint
        $0.layer.cornerRadius = 10
        return $0
    }(UIButton(primaryAction: action))
    
    private lazy var action = UIAction { _ in
        self.service.saveLocation(location: self.location)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        title = "Map"
        view.addSubview(map)
        view.addSubview(button)
        addConstrats()
        MapManager.shared.checkIsEnable { location in
            DispatchQueue.main.async {
                guard let location = location else {return}
                self.location = location
                let pin = MKPointAnnotation()
                pin.coordinate = location.coordinate
                self.map.region = MKCoordinateRegion(
                    center: CLLocationCoordinate2D(
                        latitude: location.coordinate.latitude,
                        longitude: location.coordinate.longitude),
                    span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
                self.map.addAnnotation(pin)
            }
        }
    }
    
    func addConstrats() {
        
        NSLayoutConstraint.activate([
            
            button.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            
        ])
    }
}
