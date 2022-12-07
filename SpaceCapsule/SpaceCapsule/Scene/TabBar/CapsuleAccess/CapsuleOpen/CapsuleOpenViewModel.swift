//
//  CapsuleOpenViewModel.swift
//  SpaceCapsule
//
//  Created by young june Park on 2022/11/15.
//

import Foundation
import RxCocoa
import RxSwift

final class CapsuleOpenViewModel: BaseViewModel {
    var disposeBag = DisposeBag()
    var coordinator: CapsuleOpenCoordinator?
    var capsuleCellItem: ListCapsuleCellItem?

    var input = Input()

    struct Input {
        let tapOpen = BehaviorSubject<Bool>(value: false)
        var viewDidDisappear = PublishSubject<Void>()
    }

    init() {
        bind()
    }

    private func bind() {
        input.viewDidDisappear.asObservable()
            .withLatestFrom(input.tapOpen)
            .withUnretained(self)
            .subscribe(onNext: { owner, tapOpen in
                if !tapOpen {
                    owner.coordinator?.finish()
                }
            })
            .disposed(by: disposeBag)

        input.tapOpen
            .withUnretained(self)
            .subscribe(onNext: { owner, tapOpen in
                if tapOpen {
                    owner.coordinator?.moveToCapsuleDetail()
                }
            })
            .disposed(by: disposeBag)
    }
}
