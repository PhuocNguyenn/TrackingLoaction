//
//  UserDefault+Rx.swift
//  TrackingLocation
//
//  Created by Phuoc Nguyen on 06/11/2022.
//

import Foundation
import RxSwift
import CoreLocation

extension UserDefaults {
    var localLocations: Observable<[CLLocationCoordinate2D]?> {
        return rx.observe(Array<CLLocationCoordinate2D>.self, "localLocations")
    }
}
