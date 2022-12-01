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
