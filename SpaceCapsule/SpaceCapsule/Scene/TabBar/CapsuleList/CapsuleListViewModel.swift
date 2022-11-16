//
//  CapsuleListViewModel.swift
//  SpaceCapsule
//
//  Created by young june Park on 2022/11/15.
//

import Foundation
import RxCocoa
import RxSwift

class CapsuleListViewModel: BaseViewModel {
    var disposeBag = DisposeBag()
    var coordinator: CapsuleListCoordinator?

    var input = Input()

    struct Input {
        var next = PublishSubject<Void>()
    }

    init() {
        bind()
    }

    private func bind() {
        input.next.asObservable()
            .subscribe(onNext: { [weak self] in
                self?.coordinator?.showCapsuleOpen()
            })
            .disposed(by: disposeBag)
    }
}
