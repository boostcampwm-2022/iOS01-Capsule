//
//  SortPolicySelectionViewModel.swift
//  SpaceCapsule
//
//  Created by young june Park on 2022/11/23.
//

import Foundation
import RxCocoa
import RxSwift

final class SortPolicySelectionViewModel: BaseViewModel {
    var disposeBag = DisposeBag()
    var coordinator: SortPolicySelectionCoordinator?
    var input = Input()

    struct Input {
        var viewWillDisappear = PublishSubject<Void>()
        var sortPolicy = PublishSubject<SortPolicy>()
    }
   
    init() {
        bind()
    }

    private func bind() {
        input.viewWillDisappear
            .withLatestFrom(input.sortPolicy)
            .withUnretained(self)
            .bind { weakSelf, sortPolicy in
                weakSelf.coordinator?.done(sortPolicy: sortPolicy)
            }
            .disposed(by: disposeBag)
    }
    
}
