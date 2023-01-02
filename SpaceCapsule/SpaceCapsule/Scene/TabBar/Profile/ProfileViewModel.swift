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
    var output = Output()

    struct Input {
        var tapSetupNotification = PublishSubject<Void>()
        var tapSetting = PublishSubject<Void>()
        var tapSignOut = PublishSubject<Void>()
        var tapDeleteAccount = PublishSubject<Void>()
    }

    struct Output {
        var clientSecret = PublishSubject<String>()
        var refreshToken = PublishSubject<String>()
        var revokeToken = PublishSubject<Void>()
        var deleteUserFromFireStore = PublishSubject<Void>()
        var deleteUserFromAuth = PublishSubject<Void>()
        var deleteImagesFromStorage = PublishSubject<Void>()
        var loadingIndicator = PublishSubject<Bool>()
    }

    init() {
        bind()
    }

    func bind() {
        output.refreshToken.bind { refreshToken in
            AppDataManager.shared.auth.revokeToken(refreshToken: refreshToken) { [weak self] error in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    self?.output.revokeToken.onNext(())
                }
            }
        }.disposed(by: disposeBag)

        output.revokeToken.bind { [weak self] _ in
            AppDataManager.shared.auth.deleteAccountFromFirestore { [weak self] error in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    self?.output.deleteUserFromFireStore.onNext(())
                }
            }
        }.disposed(by: disposeBag)

        output.deleteUserFromFireStore.bind { [weak self] _ in
            AppDataManager.shared.auth.deleteAccountFromFirestore { [weak self] error in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    self?.output.deleteUserFromAuth.onNext(())
                    self?.output.deleteImagesFromStorage.onNext(())
                }
            }
        }.disposed(by: disposeBag)

        output.deleteUserFromAuth.bind { [weak self] _ in
            AppDataManager.shared.auth.deleteAccountFromAuth { [weak self] error in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                self?.output.loadingIndicator.onNext(false)
                AppDataManager.shared.capsules.accept([])
                UserDefaultsManager.saveData(data: false, key: .isRegistered)
                self?.signOut()
            }
        }.disposed(by: disposeBag)

        output.deleteImagesFromStorage.bind { _ in
            FirebaseStorageManager.shared.deleteImagesInCapsule(capsules: AppDataManager.shared.capsules.value) { error in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
            }
        }.disposed(by: disposeBag)
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

    func deleteAccount() {
        output.loadingIndicator.onNext(true)
        AppDataManager.shared.auth.refreshToken().subscribe(
            onNext: { [weak self] refreshToken in
                self?.output.refreshToken.onNext(refreshToken)
            },
            onError: { error in
                print(error.localizedDescription)
            }
        ).disposed(by: disposeBag)
    }
}
