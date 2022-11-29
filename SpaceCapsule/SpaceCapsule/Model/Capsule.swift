//
//  Capsule.swift
//  SpaceCapsule
//
//  Created by 장재훈 on 2022/11/23.
//

import Foundation
import FirebaseFirestore

protocol DocumentSerializable {
    init?(dictionary: [String: Any])
}

struct Capsule: CustomCodable {
    var uuid: String = UUID().uuidString
    let userId: String

    let images: [String]
    let title: String
    let description: String

    let address: String
    let simpleAddress: String
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
            "simpleAddress": simpleAddress,
            "geopoint": geopoint.dictData,
            "memoryDate": memoryDate,
            "closedDate": closedDate,
            "openCount": openCount,
        ]
    }
}

extension Capsule: DocumentSerializable {
    init?(dictionary: [String: Any]) {
        guard let uuid = dictionary["uuid"] as? String,
              let userId = dictionary["userId"] as? String,
              let images = dictionary["images"] as? [String],
              let title = dictionary["title"] as? String,
              let description = dictionary["description"] as? String,
              let address = dictionary["address"] as? String,
              let simpleAddress = dictionary["simpleAddress"] as? String,
              let geopointDict = dictionary["geopoint"] as? NSMutableDictionary,
              let memoryDate = dictionary["memoryDate"] as? Timestamp,
              let closedDate = dictionary["closedDate"] as? Timestamp,
              let openCount = dictionary["openCount"] as? Int
        else {
            return nil
        }
        guard let latitude = geopointDict["latitude"] as? Double,
              let longitude = geopointDict["longitude"] as? Double else {
            print("nsdict decode error")
            return nil
        }
        
        self.init(uuid: uuid, userId: userId, images: images, title: title,
                  description: description, address: address, simpleAddress: simpleAddress,
                  geopoint: GeoPoint(latitude: latitude, longitude: longitude), memoryDate: memoryDate.dateValue(),
                  closedDate: closedDate.dateValue(), openCount: openCount
        )
    }

}
