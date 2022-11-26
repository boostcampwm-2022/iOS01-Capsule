//
//  CustomCodable.swift
//  SpaceCapsule
//
//  Created by 장재훈 on 2022/11/26.
//

import Foundation

protocol CustomCodable: Codable {
    var dictData: [String: Any] { get }
}
