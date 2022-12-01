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
    var capsuleCellModel: CapsuleCellModel?

    var input = Input()
    var output = Output()

    struct Input {
        var popViewController = PublishSubject<Void>()
        var openButtonTapped = PublishSubject<Void>()
        var capsuleCellModel = PublishSubject<CapsuleCellModel>()
    }
    
    struct Output {
        var isOpenable = PublishSubject<Bool>()
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
