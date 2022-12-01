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
    var capsuleCellModel: ListCapsuleCellModel?

    var input = Input()
    var output = Output()

    struct Input {
        var popViewController = PublishSubject<Void>()
        var openButtonTapped = PublishSubject<Void>()
        var capsuleCellModel = PublishSubject<ListCapsuleCellModel>()
    }
    
    struct Output {
        var isOpenable = PublishSubject<Bool>()
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
        
        input.openButtonTapped
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.coordinator?.moveToCapsuleDetail()
            })
            .disposed(by: disposeBag)
    }
}
