//
//  RefreshTokenResponse.swift
//  SpaceCapsule
//
//  Created by young june Park on 2022/12/12.
//

import Foundation

struct RefreshTokenResponse: Decodable {
    let accessToken: String?
    let refreshToken: String?
    let idToken: String?

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        accessToken = try? values.decode(String.self, forKey: .accessToken)
        refreshToken = try? values.decode(String.self, forKey: .refreshToken)
        idToken = try? values.decode(String.self, forKey: .idToken)
    }

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case idToken = "id_token"
    }
}
