//
//  SortPolicy.swift
//  SpaceCapsule
//
//  Created by young june Park on 2022/11/27.
//

import Foundation

enum SortPolicy: String, CustomStringConvertible, CaseIterable {
    case nearest
    case furthest
    case latest
    case oldest
    
    var description: String {
        switch self {
        case .nearest: return "가까운 순"
        case .furthest: return "멀리 있는 순"
        case .latest: return "최신 순"
        case .oldest: return "오래된 순"
        }
    }
}
