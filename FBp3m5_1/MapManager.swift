//
//  MapManager.swift
//  FBp3m5_1
//
//  Created by Amina TomasMart on 28.03.2024.
//

import Foundation
import CoreLocation

class MapManager: NSObject, CLLocationManagerDelegate {
    
    static let shared = MapManager()
    var mapManager: CLLocationManager?
    private var completion: ((CLLocation?) -> ())?
    
    func checkIsEnable(completion: @escaping (CLLocation?) -> ()) {
        mapManager = CLLocationManager()
        mapManager?.requestWhenInUseAuthorization()
        mapManager?.delegate = self
        self.completion = completion
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkAuth()
    }
    
    private func checkAuth() {
        
        guard let mapManager = mapManager else {return}
        
        switch mapManager.authorizationStatus {
            
        case .notDetermined:
            mapManager.requestWhenInUseAuthorization()
        case .restricted:
            print("Ограничено")
        case .denied:
            print("Отключено")
            mapManager.requestLocation()
        case .authorizedAlways, .authorizedWhenInUse, .authorized:
            self.completion?(mapManager.location)
        @unknown default:
            print("Error")
        }
    }
}
