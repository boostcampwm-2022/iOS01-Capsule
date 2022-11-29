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
    let closedDate: String
    let memoryDate: String
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
    
    func dateToInt() -> Int {
        let arr = memoryDate.split(separator: " ")
        let year = arr[0].replacingOccurrences(of: "년", with: "")
        var month = arr[1].replacingOccurrences(of: "월", with: "")
        var day = arr[2].replacingOccurrences(of: "일", with: "")
        if month.count == 1 {
            month = "0" + month
        }
        if day.count == 1 {
            day = "0" + day
        }
        guard let result = Int(year + month + day) else {
            return 0
        }
        return result
    }
    
    func distance(from: CLLocationCoordinate2D) -> Double {
        let latitudeDistance = abs(from.latitude - coordinate.latitude)
        let longitudeDistance = abs(from.longitude - coordinate.longitude)
        
        return sqrt(pow(latitudeDistance, 2) + pow(longitudeDistance, 2))
    }
}
