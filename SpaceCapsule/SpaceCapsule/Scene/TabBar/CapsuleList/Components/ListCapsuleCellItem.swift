//
//  CapsuleCellModel.swift
//  SpaceCapsule
//
//  Created by young june Park on 2022/11/24.
//

import CoreLocation
import UIKit

struct ListCapsuleCellItem {
    let uuid: String
    let thumbnailImageURL: String
    let address: String
    let closedDate: Date
    let memoryDate: Date
    let coordinate: CLLocationCoordinate2D

    var isOpenable: Bool {
        LocationManager.shared.isOpenable(capsuleCoordinate: coordinate)
    }

    func distance() -> Double {
        return LocationManager.shared.distance(capsuleCoordinate: coordinate)
    }
}

extension ListCapsuleCellItem: Hashable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.uuid == rhs.uuid
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
}
