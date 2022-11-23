//
//  Encodable+.swift
//  SpaceCapsule
//
//  Created by 장재훈 on 2022/11/23.
//

import Foundation

extension Encodable {
    var toDict: [String: Any]? {
        guard let object = try? JSONEncoder().encode(self),
              let dict = try? JSONSerialization.jsonObject(with: object, options: []) as? [String: Any] else {
            return nil
        }

        return dict
    }
}
