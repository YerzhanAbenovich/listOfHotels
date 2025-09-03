//
//  File.swift
//  ListOfHotels
//
//  Created by Yerzhan Parimbay on 02.09.2025.
//

import Foundation
import CoreLocation

struct Hotel {
    var name = ""
    var address = ""
    var image = ""
    var coordinate = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
}
