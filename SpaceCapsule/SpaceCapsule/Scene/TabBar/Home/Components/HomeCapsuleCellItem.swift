//
//  HomeCapsuleCellModel.swift
//  SpaceCapsule
//
//  Created by 김민중 on 2022/11/29.
//

import CoreLocation
import UIKit

enum CapsuleType: CaseIterable {
    case nearest
    case farthest
    case closedShortest
    case closedLongest
    case memoryNewest
    case memoryOldest
    case leastOpened
    case mostOpened

    var title: String {
        switch self {
        case .nearest:
            return "가장 가까운 위치의 캡슐"
        case .farthest:
            return "가장 먼 위치의 캡슐"
        case .closedShortest:
            return "가장 최근에 생성한 캡슐"
        case .closedLongest:
            return "가장 오래전 생성한 캡슐"
        case .memoryNewest:
            return "가장 최근 추억이 담긴 캡슐"
        case .memoryOldest:
            return "가장 오랜 추억이 담긴 캡슐"
        case .leastOpened:
            return "열어본 횟수가 가장 적은 캡슐"
        case .mostOpened:
            return "열어본 횟수가 가장 많은 캡슐"
        }
    }

    func capsule(from capsules: [Capsule]) -> Capsule? {
        switch self {
        case .closedLongest:
            return capsules.min { $0.closedDate < $1.closedDate }

        case .closedShortest:
            return capsules.min { $0.closedDate > $1.closedDate }

        case .memoryOldest:
            return capsules.min { $0.memoryDate < $1.memoryDate }

        case .memoryNewest:
            return capsules.min { $0.memoryDate > $1.memoryDate }

        case .leastOpened:
            return capsules.min { $0.openCount < $1.openCount }

        case .mostOpened:
            return capsules.min { $0.openCount > $1.openCount }

        case .nearest:
            return capsules.min {
                let first = LocationManager.shared.distance(capsuleCoordinate: $0.geopoint.coordinate)
                let second = LocationManager.shared.distance(capsuleCoordinate: $1.geopoint.coordinate)

                return first < second
            }

        case .farthest:
            return capsules.min {
                let first = LocationManager.shared.distance(capsuleCoordinate: $0.geopoint.coordinate)
                let second = LocationManager.shared.distance(capsuleCoordinate: $1.geopoint.coordinate)

                return first > second
            }
        }
    }
}

struct HomeCapsuleCellItem {
    let uuid: String
    let thumbnailImageURL: String
    let address: String
    let closedDate: Date
    let memoryDate: Date
    let openCount: Int
    let coordinate: CLLocationCoordinate2D
    let type: CapsuleType

    var isOpenable: Bool {
        LocationManager.shared.isOpenable(capsuleCoordinate: coordinate)
    }

    var description: String {
        switch type {
        case .closedLongest, .closedShortest:
            if let dDay = Calendar.current.numberOfDaysBetween(closedDate, and: Date()) {
                return "\(memoryDate.dotDateString) \(address)에서\nD+\(dDay)"
            } else {
                return "\(memoryDate.dotDateString) \(address)에서"
            }
        case .memoryOldest, .memoryNewest:
            if let dDay = Calendar.current.dateComponents([.day], from: memoryDate, to: Date()).day {
                return "\(memoryDate.dotDateString) \(address)에서\nD+\(dDay)"
            } else {
                return "\(memoryDate.dotDateString) \(address)에서"
            }
        case .nearest, .farthest:
            let distance = LocationManager.shared.distance(capsuleCoordinate: coordinate)
            if distance > 1000 {
                return "\(memoryDate.dotDateString) \(address)에서\n약 \(String(format: "%.2f", distance / 1000.0))km"
            } else {
                return "\(memoryDate.dotDateString) \(address)에서\n약 \(String(format: "%.2f", distance))m"
            }
        case .leastOpened, .mostOpened:
            return "\(memoryDate.dotDateString) \(address)에서\n\(openCount)번"
        }
    }
}

extension HomeCapsuleCellItem: Hashable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.uuid == rhs.uuid
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
}
