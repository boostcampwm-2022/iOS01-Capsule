//
//  Array+.swift
//  SpaceCapsule
//
//  Created by 장재훈 on 2022/11/26.
//

import Foundation

extension Array {
    subscript (safe index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
    }
}
