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
        let tapOpen = PublishSubject<Void>()
        let viewWillAppear = PublishSubject<Void>()
        var viewDidDisappear = PublishSubject<Void>()
    }

    init() {
        bind()
    }

    private func bind() {
        input.viewWillAppear
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.coordinator?.hideTabBar()
            })
            .disposed(by: disposeBag)

        input.viewDidDisappear.asObservable()
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.coordinator?.finish()
            })
            .disposed(by: disposeBag)

        input.tapOpen
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.coordinator?.moveToCapsuleDetail()
            })
            .disposed(by: disposeBag)
    }
}
