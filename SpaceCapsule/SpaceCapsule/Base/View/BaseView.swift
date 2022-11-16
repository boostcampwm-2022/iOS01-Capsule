//
//  BaseView.swift
//  SpaceCapsule
//
//  Created by young june Park on 2022/11/15.
//

import UIKit

protocol BaseView: UIView {
    func configure()
    func addSubViews()
    func makeConstraints()
}
