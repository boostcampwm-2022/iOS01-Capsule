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
        var closeButtonTapped = PublishSubject<Void>()
    }

    struct Output {
        var capsule: Capsule?
    }

    init(capsule: Capsule) {
        bind()

        output.capsule = capsule
    }

    private func bind() {
        input.closeButtonTapped
            .subscribe(onNext: { [weak self] in
                self?.coordinator?.finish()
            })
            .disposed(by: disposeBag)
    }
}
