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
    weak var coordinator: ProfileCoordinator?

    var input = Input()

    struct Input {
        var tapSetting = PublishSubject<Void>()
        var tapSignOut = PublishSubject<Void>()
        var tapWithdrawal = PublishSubject<Void>()
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
    }

    func signOut() {
        AppDataManager.shared.auth.signOut { error in
            if let error = error {
                print(error.localizedDescription)
                UserDefaultsManager.saveData(data: true, key: .isSignedIn)
                return
            }
        }
        UserDefaultsManager.saveData(data: false, key: .isSignedIn)
        coordinator?.moveToAuth()
    }

//    func withdrawal() {
//
//    }
}
