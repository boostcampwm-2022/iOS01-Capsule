//
//  Bindable.swift
//  SpaceCapsule
//
//  Created by young june Park on 2022/11/15.
//

import Foundation

protocol Bindable {
    var input: ViewModelInput { get }
    var output: ViewModelOutput { get }
}

protocol ViewModelInput { }

protocol ViewModelOutput { }
