//
//  Payload.swift
//  SpaceCapsule
//
//  Created by young june Park on 2022/12/12.
//

import Foundation
import SwiftJWT

struct Payload: Claims {
    var iss = "4G6ZD4247R"
    var iat = Date().epochIATTimeStamp
    var exp = Date().epochEXPTimeStamp
    var aud = "https://appleid.apple.com"
    var sub = "com.boostcamp.BoogieSpaceCapsule"
}
