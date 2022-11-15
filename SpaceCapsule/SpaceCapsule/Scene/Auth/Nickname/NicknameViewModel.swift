//
//  NicknameViewModel.swift
//  SpaceCapsule
//
//  Created by young june Park on 2022/11/15.
//

import Foundation
import RxCocoa
import RxSwift

final class NickNameViewModel: BaseViewModel {
    var disposeBag: DisposeBag = DisposeBag()
    var coordinator: NicknameCoordinator?

    var input = Input()
    var output = Output()

    struct Input: ViewModelInput {
        var nickname: PublishSubject = PublishSubject<String>()
        var doneButtonTapped: PublishSubject = PublishSubject<Void>()
    }

    struct Output: ViewModelOutput {
        var signUpCompleted: PublishSubject = PublishSubject<Bool>()
    }

    init() {
        bind()
    }

    func bind() {
        // 완료 버튼 클릭 시
        input.doneButtonTapped
            .withLatestFrom(input.nickname)
            .subscribe(onNext: {
                // 닉네임 FB 로 요청
                // 성공 시 signUpCompleted 로 bind?
                print($0)
            })
            .disposed(by: disposeBag)

        // 닉네임 입력 후 회원가입 성공 시
        output.signUpCompleted
            .observe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            .withUnretained(self)
            .subscribe(onNext: { (_: NickNameViewModel, state: Bool) in
                if state {
                    self.coordinator?.didFinish()
                } else {
                    // TODO: - 예외처리
                }
            })
            .disposed(by: disposeBag)
    }
}
