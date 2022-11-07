//
//  HomeViewModel.swift
//  TrackingLocation
//
//  Created by Phuoc Nguyen on 06/11/2022.
//

import Foundation
import CoreLocation
import RxSwift
import RxCocoa

class HomeViewModel {
    
    // MARK: - DisposeBag
    private var disposeBag = DisposeBag()
    
    // MARK: - Private properties
    let locationManager = CLLocationManager()
    
    var showListLocation: BehaviorSubject<Bool> = BehaviorSubject(value: false)
        
    // MARK: - Initialize
    init() {
        configuration()
        binding()
        requestLocationPremission()
    }
    
    // MARK: - Configuration
    private func configuration() {
        locationManager.allowsBackgroundLocationUpdates = true
    }
    
    // MARK: - Binding
    private func binding() {
        // Did change authoziration status
        locationManager.rx.didChangeAuthorization
            .subscribe(onNext: { self.didChangeAuthorization($0) })
            .disposed(by: disposeBag)
        
        // Tracking current location
        locationManager.rx
            .didUpdateLocation
            .compactMap { $0.last }
            .subscribe(onNext: { location in
                print("Tracking location: ", location)
            })
            .disposed(by: disposeBag)
        
        // Save current location when authorization status is when in use
        locationManager.rx.didUpdateLocation
            .first()
            .compactMap { $0?.first }
            .subscribe(onSuccess: { self.saveLocalLocations($0) })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Private func
    private func requestLocationPremission() {
        let status = locationManager.authorizationStatus
        if status != .authorizedWhenInUse {
            locationManager.requestWhenInUseAuthorization()
        } else {
            locationManager.startUpdatingLocation()
        }
    }

    private func didChangeAuthorization(_ status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse:
            self.locationManager.startUpdatingLocation()
        default: break
        }
    }
    
    private func saveLocalLocations(_ location: CLLocation) {
        let key = UserDefaultsKey.localLocations.rawValue
        let userDefaults = UserDefaults.standard
        
        // Get old location in UserDefault
        var locations = userDefaults.array(forKey: key) as? [[String: Double]] ?? []
        
        // Save location to userdefault
        let locationJson = location.toJson()
        if !locations.contains(locationJson) {
            locations.append(locationJson)
        }
        userDefaults.set(locations, forKey: key)
    }
}
