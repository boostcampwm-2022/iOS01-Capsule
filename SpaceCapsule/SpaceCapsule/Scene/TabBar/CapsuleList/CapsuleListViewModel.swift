//
//  CapsuleListViewModel.swift
//  SpaceCapsule
//
//  Created by young june Park on 2022/11/15.
//

import Foundation
import RxCocoa
import RxSwift

class CapsuleListViewModel: BaseViewModel {
    var disposeBag = DisposeBag()
    var coordinator: CapsuleListCoordinator?

    var input = Input()

    struct Input {
        // 임시
        var next = PublishSubject<Void>()
    }

    init() {
        bind()
    }

    private func bind() {
        // 임시, 다음 버튼 클릭 시 화면이동
        input.next.asObservable()
            .subscribe(onNext: { [weak self] in
                self?.coordinator?.showCapsuleOpen()
            })
            .disposed(by: disposeBag)
    }
}
