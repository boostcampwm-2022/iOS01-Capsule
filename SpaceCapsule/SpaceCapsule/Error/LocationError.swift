//
//  LocationError.swift
//  SpaceCapsule
//
//  Created by 장재훈 on 2022/11/26.
//

import Foundation

enum LocationError: LocalizedError {
    case invalidGeopoint
    
    var errorDescription: String? {
        switch self {
        case .invalidGeopoint:
            return "해당 지역의 주소를 불러올 수 없습니다."
        }
    }
}
