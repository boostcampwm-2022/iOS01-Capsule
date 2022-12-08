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
        var tapClose = PublishSubject<Void>()
    }

    struct Output {
        var capsule = BehaviorSubject<Capsule?>(value: nil)
    }

    init(capsule: Capsule) {
        bind()

        output.capsule.onNext(capsule)
    }

    private func bind() {
        input.tapClose
            .subscribe(onNext: { [weak self] in
                AppDataManager.shared.fetchCapsules()
                self?.coordinator?.finish()
            })
            .disposed(by: disposeBag)
    }
}
