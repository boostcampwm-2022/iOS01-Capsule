//
//  BaseView.swift
//  SpaceCapsule
//
//  Created by young june Park on 2022/11/15.
//

import Foundation

protocol BaseView: AnyObject {
    func configure()
    func addSubViews()
    func makeConstraints()
    
}
