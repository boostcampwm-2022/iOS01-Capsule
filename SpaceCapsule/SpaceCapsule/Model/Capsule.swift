//
//  Capsule.swift
//  SpaceCapsule
//
//  Created by 장재훈 on 2022/11/23.
//

import Foundation

struct Capsule: CustomCodable {
    var uuid: String = UUID().uuidString
    let userId: String

    let images: [String]
    let title: String
    let description: String

    let address: String
    let geopoint: GeoPoint
    let memoryDate: Date
    var closedDate: Date = Date()
    let openCount: Int

    var dictData: [String: Any] {
        [
            "uuid": uuid,
            "userId": userId,
            "images": images,
            "title": title,
            "description": description,
            "address": address,
            "geopoint": geopoint.dictData,
            "memoryDate": memoryDate,
            "closedDate": closedDate,
            "openCount": openCount,
        ]
    }
}

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
