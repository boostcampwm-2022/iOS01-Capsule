//
//  UIControl+Rx.swift
//  SpaceCapsule
//
//  Created by 장재훈 on 2022/12/07.
//

import RxSwift
import RxCocoa
import UIKit

extension Reactive where Base: UIControl {
    var tap: ControlEvent<Void> {
        return controlEvent(.touchUpInside)
    }
}
