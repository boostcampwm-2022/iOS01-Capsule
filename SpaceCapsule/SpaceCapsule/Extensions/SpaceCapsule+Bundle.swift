//
//  SpaceCapsule+Bundle.swift
//  SpaceCapsule
//
//  Created by young june Park on 2022/12/24.
//

import Foundation

extension Bundle {
    var authKey: String {
        guard let file = self.path(forResource: "AuthKey", ofType: ".plist"),
              let url = URL(string: file) else {
            return ""
        }
    
        guard let resource = try? NSDictionary(contentsOf: url, error: ()) else {
            return ""
        }
        guard let key = resource["AuthKey"] as? String else {
            fatalError("AuthKey.plist에 authKey를 등록하세요")
        }
        return key
    }
}
