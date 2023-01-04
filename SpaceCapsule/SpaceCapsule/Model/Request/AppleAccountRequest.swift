//
//  AppleAccountRequest.swift
//  SpaceCapsule
//
//  Created by young june Park on 2023/01/03.
//

import Foundation

enum HttpMethod: String {
    case post = "POST"
    case get = "GET"

    var text: String {
        return rawValue
    }
}

enum AppleAccountEndPoint: String {
    case auth

    var text: String {
        return rawValue
    }
}

struct AppleAccountRequest {
    private struct Constant {
        static let baseURL: String = "https://appleid.apple.com"
    }

    private let endPoint: AppleAccountEndPoint
    private let pathComponents: [String]
    private let queryParameters: [URLQueryItem]
    let headerFields: [String: String]
    let httpMethod: HttpMethod
    let requestBodyComponents: URLComponents

    var urlString: String {
        var string = Constant.baseURL
        string += "/\(endPoint.text)"
        
        if !pathComponents.isEmpty {
            pathComponents.forEach {
                string += "/\($0)"
            }
        }
        
        if !queryParameters.isEmpty {
            string += "?"
            let argumentString = queryParameters.compactMap {
                guard let value = $0.value else {
                    return nil
                }
                return "\($0.name)=\(value)"
            }.joined(separator: "&")
            string += argumentString
        }
        
        return string
    }
    var url: URL? {
        return URL(string: urlString)
    }

    init(endPoint: AppleAccountEndPoint,
         pathComponents: [String],
         queryParameters: [URLQueryItem],
         headerFields: [String: String],
         httpMethod: HttpMethod,
         requestBodyComponents: URLComponents) {
        self.endPoint = endPoint
        self.pathComponents = pathComponents
        self.queryParameters = queryParameters
        self.headerFields = headerFields
        self.httpMethod = httpMethod
        self.requestBodyComponents = requestBodyComponents
    }
}
