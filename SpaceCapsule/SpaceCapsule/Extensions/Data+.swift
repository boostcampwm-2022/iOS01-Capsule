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

struct Header: Encodable {
    let alg = "ES256"
    let kid = "4979Z7MUXJ"
}

struct Payload: Encodable {
    let iss = "4G6ZD4247R"
    let iat = Date().epochIATTimeStamp
    let exp = Date().epochEXPTimeStamp
    let aud = "https://appleid.apple.com"
    let sub = "com.boostcamp.BoogieSpaceCapsule"
}
