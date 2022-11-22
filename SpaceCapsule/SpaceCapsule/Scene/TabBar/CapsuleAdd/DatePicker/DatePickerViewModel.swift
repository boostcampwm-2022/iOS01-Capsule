//
//  DatePickerViewModel.swift
//  SpaceCapsule
//
//  Created by 장재훈 on 2022/11/22.
//

import Foundation
import RxCocoa
import RxSwift

final class DatePickerViewModel: BaseViewModel {
    var disposeBag = DisposeBag()
    var coordinator: DatePickerCoordinator?

    var input = Input()

    struct Input {
        var viewWillDisappear = PublishSubject<Void>()
    }

    init() {
        bind()
    }

    func bind() {
        input.viewWillDisappear.asObservable()
            .subscribe(onNext: { [weak self] in
                self?.coordinator?.finish()
            })
            .disposed(by: disposeBag)
    }
}
