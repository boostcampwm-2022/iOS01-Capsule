//
//  GeoPoint.swift
//  SpaceCapsule
//
//  Created by young june Park on 2022/11/29.
//

import CoreLocation
import FirebaseFirestore
import Foundation

struct GeoPoint: CustomCodable {
    let latitude: Double
    let longitude: Double

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    var dictData: [String: Any] {
        [
            "latitude": latitude,
            "longitude": longitude,
        ]
    }
}
