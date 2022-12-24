//
//  SpaceCapsule+Bundle.swift
//  SpaceCapsule
//
//  Created by young june Park on 2022/12/24.
//

import Foundation

extension Bundle {
    var authKey: String? {
        guard let file = path(forResource: "AuthKey", ofType: "plist"),
              let resource = try? NSDictionary(contentsOf: NSURL(fileURLWithPath: file) as URL, error: ()),
              let key = resource["AuthKey"] as? String else {
            return nil
        }
        
        return key
    }
}
