//
//  Capsule.swift
//  SpaceCapsule
//
//  Created by 장재훈 on 2022/11/23.
//

import Foundation

struct Capsule: Codable {
    var uuid: String = UUID().uuidString
    let userId: String

    let images: [String]
    let title: String
    let description: String

    let address: String
    let geopoint: GeoPoint
    let memoryDate: String
    var closedDate: String = Date().dateTimeString
    let openCount: Int
}

struct GeoPoint: Codable {
    let latitude: Double
    let longitude: Double
}
