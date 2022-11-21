//
//  CapsuleOpenViewModel.swift
//  SpaceCapsule
//
//  Created by young june Park on 2022/11/15.
//

import Foundation
import RxCocoa
import RxSwift

class CapsuleOpenViewModel: BaseViewModel {
    var disposeBag = DisposeBag()
    var coordinator: CapsuleOpenCoordinator?

    var input = Input()

    struct Input {
        var popViewController = PublishSubject<Void>()
    }

    init() {
        bind()
    }

    private func bind() {
        input.popViewController.asObservable()
            .subscribe(onNext: { [weak self] in
                self?.coordinator?.finish()
            })
            .disposed(by: disposeBag)
    }
}
