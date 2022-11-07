//
//  LocationTableViewCell.swift
//  TrackingLocation
//
//  Created by Phuoc Nguyen on 07/11/2022.
//

import UIKit
import CoreLocation

class LocationTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var latLabel: UILabel!
    @IBOutlet private weak var longLabel: UILabel!
    
    var location: CLLocation? {
        didSet {
            if let lat = location?.coordinate.latitude, let long = location?.coordinate.longitude {
                latLabel.text = "lat: \(lat)"
                longLabel.text = "long: \(long)"
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
