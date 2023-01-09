//
//  BaseTestCase.swift
//  BaseTestCase
//
//  Created by 장재훈 on 2023/01/09.
//

import XCTest

class BaseTestCase: XCTestCase {
    func given(_ task: () -> Void) {
        task()
    }

    func when(_ task: () -> Void) {
        task()
    }

    func then(_ task: () -> Void) {
        task()
    }
}
