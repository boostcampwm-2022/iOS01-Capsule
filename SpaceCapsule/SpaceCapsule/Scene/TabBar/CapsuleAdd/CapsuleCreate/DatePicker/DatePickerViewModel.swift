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
        var dateString = PublishSubject<String>()
    }

    init() {
        bind()
    }

    func bind() {
        input.viewWillDisappear
            .withLatestFrom(input.dateString)
            .subscribe(onNext: { [weak self] in
                self?.coordinator?.done(dateString: $0)
            })
            .disposed(by: disposeBag)
    }
}
