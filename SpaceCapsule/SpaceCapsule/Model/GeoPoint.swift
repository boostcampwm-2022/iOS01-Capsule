//
//  GeoPoint.swift
//  SpaceCapsule
//
//  Created by young june Park on 2022/11/29.
//

import Foundation
import FirebaseFirestore

struct GeoPoint: CustomCodable {
    let latitude: Double
    let longitude: Double
    
    var dictData: [String: Any] {
        [
            "latitude": latitude,
            "longitude": longitude,
        ]
    }
}
