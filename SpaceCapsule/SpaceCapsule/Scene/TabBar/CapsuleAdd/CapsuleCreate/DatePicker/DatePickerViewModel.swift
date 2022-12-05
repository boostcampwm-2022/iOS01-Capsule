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
        var tapDone = PublishSubject<Void>()
        var tapCancel = PublishSubject<Void>()
        var date = PublishSubject<Date>()
    }

    init() {
        bind()
    }

    func bind() {
        input.tapDone
            .withLatestFrom(input.date)
            .subscribe(onNext: { [weak self] in
                self?.coordinator?.done(date: $0)
            })

        input.tapCancel
            .subscribe(onNext: { [weak self] in
                self?.coordinator?.done(date: nil)
            })
            .disposed(by: disposeBag)
    }
}
