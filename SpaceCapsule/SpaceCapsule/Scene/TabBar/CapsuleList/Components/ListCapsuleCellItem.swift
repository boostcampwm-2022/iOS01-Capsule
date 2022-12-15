//
//  CapsuleCellModel.swift
//  SpaceCapsule
//
//  Created by young june Park on 2022/11/24.
//

import CoreLocation
import UIKit

struct ListCapsuleCellItem: Hashable, Equatable {
    let uuid: String
    let thumbnailImageURL: String
    let address: String
    let closedDate: Date
    let memoryDate: Date
    let coordinate: CLLocationCoordinate2D

    func isOpenable() -> Bool {
        return LocationManager.shared.isOpenable(capsuleCoordinate: coordinate) ? true : false
    }

    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.uuid == rhs.uuid
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }

    func distance() -> Double {
        return LocationManager.shared.distance(capsuleCoordinate: coordinate)
    }
}
