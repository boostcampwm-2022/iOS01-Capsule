//
//  HomeCapsuleCellModel.swift
//  SpaceCapsule
//
//  Created by 김민중 on 2022/11/29.
//

import UIKit
import CoreLocation

enum CapsuleType: CaseIterable {
    case closedOldest
    case closedNewest
    case memoryOldest
    case memoryNewest
    case nearest
    case farthest
    case leastOpened
    
    var title: String {
        switch self {
        case .closedOldest:
            return "밀봉한지 가장 오래된 캡슐"
        case .closedNewest:
            return "가장 최근에 생성한 캡슐"
        case .memoryOldest:
            return "가장 오래된 추억이 담긴 캡슐"
        case .memoryNewest:
            return "가장 최근 추억이 담긴 캡슐"
        case .nearest:
            return "가장 가까운 위치의 캡슐"
        case .farthest:
            return "가장 먼 위치의 캡슐"
        case .leastOpened:
            return "열어본 횟수가 가장 적은 캡슐"
        }
    }
}

struct HomeCapsuleCellItem: Hashable, Equatable {
    let uuid: String
    let thumbnailImageURL: String?
    let address: String
    let closedDate: Date
    let memoryDate: Date
    let openCount: Int
    let coordinate: CLLocationCoordinate2D
    let type: CapsuleType
    
    func isOpenable() -> Bool {
        return LocationManager.shared.isOpenable(capsuleCoordinate: coordinate) ? true : false
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.uuid == rhs.uuid
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
    
    func distance() -> Double {
        return LocationManager.shared.distance(capsuleCoordinate: coordinate)
    }
    
    func description() -> String {
        switch type {
        case .closedOldest, .closedNewest:
            // TODO: D+Day 계산하는 방법 수정해야 할 듯
            if let dDay = Calendar.current.dateComponents([.day], from: closedDate, to: Date()).day {
                return "\(memoryDate.dotDateString) \(address)에서\nD+\(dDay)"
            } else {
                return "\(memoryDate.dotDateString) \(address)에서"
            }
        case .memoryOldest, .memoryNewest:
//            return "추억일자 : \(memoryDate.dateString)"
            if let dDay = Calendar.current.dateComponents([.day], from: memoryDate, to: Date()).day {
                return "\(memoryDate.dotDateString) \(address)에서\nD+\(dDay)"
            } else {
                return "\(memoryDate.dotDateString) \(address)에서"
            }
        case .nearest, .farthest:
            let distance = LocationManager.shared.distance(capsuleCoordinate: coordinate)
            if distance > 1000 {
                return "\(memoryDate.dotDateString) \(address)에서\n약 \(String(format: "%.2f", (distance / 1000.0)))km"
            } else {
                return "\(memoryDate.dotDateString) \(address)에서\n약 \(String(format: "%.2f", distance))m"
            }
        case .leastOpened:
            return "\(memoryDate.dotDateString) \(address)에서\n\(openCount)번"
        }
    }
}
