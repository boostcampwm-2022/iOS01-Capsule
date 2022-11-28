//
//  KakaoAPIManager.swift
//  SpaceCapsule
//
//  Created by jisu on 2022/11/16.
//

import Foundation

final class KakaoAPIManager {
    static let shared = KakaoAPIManager()

    private let baseURLString = "https://dapi.kakao.com/v2/local"
    
    private init () {}

    enum APIType {
        case coordToAddress(Coord)
        typealias Coord = (x: String, y: String)

        var path: String {
            switch self {
            case let .coordToAddress(coord): return "/geo/coord2address.json?input_coord=WGS84&x=\(coord.x)&y=\(coord.y)"
            }
        }
    }

    func getRequest(for apiType: APIType) throws -> URLRequest {
        guard let url = URL(string: "\(baseURLString)\(apiType.path)") else {
            throw NetworkError.failedConvertingStringToUrl
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = RequestType.GET
        request.setValue("KakaoAK \(Key.kakao)", forHTTPHeaderField: "Authorization")
        
        return request
    }
}
