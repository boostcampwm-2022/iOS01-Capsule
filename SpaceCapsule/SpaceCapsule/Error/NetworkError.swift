//
//  NetworkManager.swift
//  SpaceCapsule
//
//  Created by jisu on 2022/11/17.
//

import Foundation

enum NetworkError: Error {
    case failedConvertingStringToUrl
    case decodingError
    case refreshTokenError
    case revokeTokenError
    case clientSecretError

    var errorDescription: String {
        switch self {
        case .failedConvertingStringToUrl:
            return "failedConvertingStringToUrl"
        case .decodingError:
            return "decodingError"
        case .refreshTokenError:
            return "refreshTokenError"
        case .revokeTokenError:
            return "revokeTokenError"
        case .clientSecretError:
            return "clientSecretError"
        }
    }
}
