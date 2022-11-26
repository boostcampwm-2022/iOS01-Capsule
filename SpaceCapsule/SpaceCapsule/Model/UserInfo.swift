//
//  UserInfo.swift
//  SpaceCapsule
//
//  Created by 장재훈 on 2022/11/26.
//

import Foundation

struct UserInfo: CustomCodable {
    let email: String?
    let nickname: String?

    var dictData: [String: Any] {
        [
            "email": email,
            "nickname": nickname,
        ]
    }
}
