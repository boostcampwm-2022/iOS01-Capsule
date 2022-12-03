//
//  ProfileViewModel.swift
//  SpaceCapsule
//
//  Created by young june Park on 2022/11/15.
//

import Foundation
import RxSwift

final class ProfileViewModel: BaseViewModel {
    var disposeBag = DisposeBag()
    var coordinator: ProfileCoordinator?

    var input = Input()

    struct Input {
        var tapSetting = PublishSubject<Void>()
        var tapLogOut = PublishSubject<Void>()
        var tapSignOut = PublishSubject<Void>()
    }

    init() {
        bind()
    }

    func bind() {
        input.tapSetting
            .bind {
                print(1)
            }
            .disposed(by: disposeBag)

        input.tapLogOut
            .bind {
                print(2)
            }
            .disposed(by: disposeBag)

        input.tapSignOut
            .bind {
                print(3)
            }
            .disposed(by: disposeBag)
    }
}
