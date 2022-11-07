//
//  DoubleExt.swift
//  TrackingLocation
//
//  Created by Phuoc Nguyen on 07/11/2022.
//

import Foundation

extension Double {
    func round(to places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
