//
//  CLLocation.swift
//  TrackingLocation
//
//  Created by Phuoc Nguyen on 07/11/2022.
//

import Foundation
import CoreLocation

extension CLLocation {
    
    enum Key: String {
        case latitude = "latitude"
        case longitude = "longitude"
    }
    
    public convenience init?(_ dict: [String: Double]) {
        guard let lat = dict[Key.latitude.rawValue],
              let long = dict[Key.longitude.rawValue] else {
            return nil
        }
        self.init(latitude: lat, longitude: long)
    }
    
    func toJson() -> [String: Double] {
        return [
            Key.latitude.rawValue: coordinate.latitude.round(to: 6),
            Key.longitude.rawValue: coordinate.longitude.round(to: 6),
        ]
    }
}
