//
//  HomeCapsuleCellModel.swift
//  SpaceCapsule
//
//  Created by 김민중 on 2022/11/29.
//

import UIKit
import CoreLocation

struct HomeCapsuleCellModel: Hashable, Equatable {
    let uuid: String
    let thumbnailImageURL: String?
    let address: String
    let closedDate: Date
    let memoryDate: Date
    let coordinate: CLLocationCoordinate2D
    
    func isOpenable() -> Bool {
        let distance = distance()
        return (distance <= 100.0) ? true : false
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.uuid == rhs.uuid
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
    
    func distance() -> Double {
        guard let currentCoordinate = LocationManager.shared.coordinate else {
            return 0.0
        }
        let currentLocation = LocationManager.shared.location(currentCoordinate)
        let capsuleLocation = LocationManager.shared.location(coordinate)
        return currentLocation.distance(from: capsuleLocation)
    }
}
