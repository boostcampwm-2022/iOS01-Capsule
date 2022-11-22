//
//  CapsuleListViewModel.swift
//  SpaceCapsule
//
//  Created by young june Park on 2022/11/15.
//

import Foundation
import RxCocoa
import RxSwift

final class CapsuleListViewModel: BaseViewModel {
    var disposeBag = DisposeBag()
    var coordinator: CapsuleListCoordinator?

    var input = Input()

    struct Input {
        var capsuleCellModels = PublishSubject<[CapsuleCellModel]>()
    }

    init() {
        bind()
    }

    private func bind() {
    }
    
}
