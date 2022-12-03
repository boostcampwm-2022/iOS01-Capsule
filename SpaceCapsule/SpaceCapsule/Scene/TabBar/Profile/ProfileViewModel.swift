//
//  ProfileViewModel.swift
//  SpaceCapsule
//
//  Created by young june Park on 2022/11/15.
//

import Foundation
import RxSwift

final class ProfileViewModel: BaseViewModel {
    var disposeBag = DisposeBag()
    var coordinator: ProfileCoordinator?

    var input = Input()

    struct Input {
    }

    init() { bind() }

    func bind() {
    }
}
