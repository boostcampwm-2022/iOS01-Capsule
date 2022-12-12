//
//  Data+.swift
//  SpaceCapsule
//
//  Created by young june Park on 2022/12/10.
//

import CryptoKit
import Foundation

extension Data {
    func urlSafeBase64EncodedString() -> String {
        return base64EncodedString()
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
    }
}
