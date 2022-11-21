//
//  CapsuleCloseViewModel.swift
//  SpaceCapsule
//
//  Created by young june Park on 2022/11/15.
//

import Foundation
import RxCocoa
import RxSwift

class CapsuleCloseViewModel: BaseViewModel {
    var disposeBag = DisposeBag()
    var coordinator: CapsuleCloseCoordinator?

    var input = Input()
    var output = Output()

    struct Input {
        var popViewController = PublishSubject<Void>()
        var closeButtonTapped = PublishSubject<Void>()
    }
    
    struct Output {}

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
