//
//  BaseViewController.swift
//  SpaceCapsule
//
//  Created by young june Park on 2022/11/15.
//

import Foundation
import RxSwift

protocol BaseViewController: AnyObject {
    var disposeBag: DisposeBag { get }
    func bind()
}
