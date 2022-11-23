//
//  Capsule.swift
//  SpaceCapsule
//
//  Created by 장재훈 on 2022/11/23.
//

import Foundation

struct Capsule {
    let uuid: String = UUID().uuidString
    let userId: String

    let images: [String]
    let title: String
    let description: String

//    let address: String
//    let geoPoint: GeoPoint
//    let memoryDate: String
//    let closedDate: String

    let openCount: Int
}

struct GeoPoint {
    let latitude: Double
    let longitude: Double
}
