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
        var popViewController = PublishSubject<Void>()
    }

    init() {
        bind()
    }

    private func bind() {
        input.popViewController.asObservable()
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.coordinator?.finish()
            })
            .disposed(by: disposeBag)
    }
}
