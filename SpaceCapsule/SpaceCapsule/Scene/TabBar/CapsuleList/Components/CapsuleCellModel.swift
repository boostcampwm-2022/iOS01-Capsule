//
//  CapsuleCellModel.swift
//  SpaceCapsule
//
//  Created by young june Park on 2022/11/24.
//

import UIKit
import CoreLocation

struct CapsuleCellModel: Hashable, Equatable {
    let uuid: String
    let thumbnailImageURL: String?
    let address: String
    let closedDate: Date
    let memoryDate: Date
    let coordinate: CLLocationCoordinate2D
    
    var isOpenable: Bool = {
        var isOpenable = true
        return isOpenable
    }()
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.uuid == rhs.uuid
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
    
    func distance(from: CLLocationCoordinate2D) -> Double {
        let latitudeDistance = abs(from.latitude - coordinate.latitude)
        let longitudeDistance = abs(from.longitude - coordinate.longitude)
        
        return sqrt(pow(latitudeDistance, 2) + pow(longitudeDistance, 2))
    }
}
