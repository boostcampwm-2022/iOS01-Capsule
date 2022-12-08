//
//  ProfileViewController.swift
//  SpaceCapsule
//
//  Created by young june Park on 2022/11/15.
//

import RxCocoa
import RxSwift
import UIKit

enum Authorization: String {
    case notification
    case location

    var description: String {
        switch self {
        case .notification: return "알림 권한"
        case .location: return "위치정보 권한"
        }
    }
}

final class ProfileViewController: UIViewController, BaseViewController {
    var disposeBag = DisposeBag()
    var viewModel: ProfileViewModel?
    let profileView = ProfileView()

    override func loadView() {
        view = profileView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        bind()
        bindViewModel()
    }

    func bind() {
        guard let viewModel else {
            return
        }
        profileView.notificationButton.rx.tap
            .bind {
                viewModel.input.tapSetupNotification.onNext(())
            }
            .disposed(by: disposeBag)
        profileView.settingButton.rx.tap
            .bind {
                viewModel.input.tapSetting.onNext(())
            }
            .disposed(by: disposeBag)

        profileView.signOutButton.rx.tap
            .bind {
                viewModel.input.tapSignOut.onNext(())
            }
            .disposed(by: disposeBag)

        profileView.deleteAccountButton.rx.tap
            .bind {
                viewModel.input.tapWithdrawal.onNext(())
            }
            .disposed(by: disposeBag)
    }

    func bindViewModel() {
        guard let viewModel else {
            return
        }
        viewModel.input.tapSetupNotification
            .withUnretained(self)
            .bind { owner, _ in
                NotificationManager.shared.checkNotificationAuthorization { isAuthorized in
                    if isAuthorized {
                        owner.showAlreadyAllowed(type: .notification)
                    } else {
                        owner.showRequestAuthorization(type: .notification)
                    }
                }
            }
            .disposed(by: disposeBag)
        viewModel.input.tapSetting
            .withUnretained(self)
            .bind { owner, _ in
                LocationManager.shared.checkLocationAuthorization { isAuthorized in
                    if isAuthorized {
                        owner.showAlreadyAllowed(type: .location)
                    } else {
                        owner.showRequestAuthorization(type: .location)
                    }
                }
            }
            .disposed(by: disposeBag)

        viewModel.input.tapSignOut
            .withUnretained(self)
            .bind { owner, _ in
                owner.showSignOutAlert()
            }
            .disposed(by: disposeBag)

        viewModel.input.tapWithdrawal
            .withUnretained(self)
            .bind { owner, _ in
                owner.showDeleteAccountAlert()
            }
            .disposed(by: disposeBag)
    }

    private func showSignOutAlert() {
        let alertController = UIAlertController(title: "로그아웃", message: "로그아웃 하시겠습니까?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let acceptAction = UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
            self?.viewModel?.signOut()
        })
        alertController.addAction(cancelAction)
        alertController.addAction(acceptAction)
        present(alertController, animated: true, completion: nil)
    }

    private func showDeleteAccountAlert() {
        let alertController = UIAlertController(title: "회원 탈퇴", message: "탈퇴 하시겠습니까?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let acceptAction = UIAlertAction(title: "OK", style: .destructive, handler: { [weak self] _ in
            self?.viewModel?.deleteAccount()
        })
        alertController.addAction(cancelAction)
        alertController.addAction(acceptAction)
        present(alertController, animated: true, completion: nil)
    }

    private func showAlreadyAllowed(type: Authorization) {
        let alertController = UIAlertController(title: type.description, message: "이미 동의하셨습니다.", preferredStyle: .alert)
        let acceptAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        alertController.addAction(acceptAction)
        DispatchQueue.main.async { [weak self] in
            self?.present(alertController, animated: true, completion: nil)
        }
    }

    private func showRequestAuthorization(type: Authorization) {
        guard let url = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        let alertController = UIAlertController(title: type.description, message: "앱 설정에서 \(type.description)을 허용해주세요.", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let acceptAction = UIAlertAction(title: "OK", style: .default, handler: { _ in
            UIApplication.shared.open(url)
        })
        alertController.addAction(cancelAction)
        alertController.addAction(acceptAction)
        DispatchQueue.main.async { [weak self] in
            self?.present(alertController, animated: true, completion: nil)
        }
    }
}
