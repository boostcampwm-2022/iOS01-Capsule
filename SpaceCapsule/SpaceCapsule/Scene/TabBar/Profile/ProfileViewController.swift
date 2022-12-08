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
                owner.checkNotificationAuthorization()
            }
            .disposed(by: disposeBag)
        viewModel.input.tapSetting
            .withUnretained(self)
            .bind { owner, _ in
                owner.checkLocationAuthorization()
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
                owner.showWithdrawalAlert()
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

    private func showWithdrawalAlert() {
        let alertController = UIAlertController(title: "회원 탈퇴", message: "탈퇴 하시겠습니까?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let acceptAction = UIAlertAction(title: "OK", style: .destructive, handler: { [weak self] _ in
            self?.viewModel?.deleteAccount()
        })
        alertController.addAction(cancelAction)
        alertController.addAction(acceptAction)
        present(alertController, animated: true, completion: nil)
    }

    func checkLocationAuthorization() {
        switch AppDataManager.shared.location.core.authorizationStatus {
        case .denied:
            showRequestAuthorization(type: .location)
        case .notDetermined, .restricted:
            AppDataManager.shared.location.core.requestWhenInUseAuthorization()
        default:
            showAlreadyAllowed(type: .location)
            return
        }
    }

    func checkNotificationAuthorization() {
        NotificationManager.shared.userNotificationCenter.getNotificationSettings { [weak self] setting in
            switch setting.authorizationStatus {
            case .authorized:
                self?.showAlreadyAllowed(type: .notification)
            default:
                self?.showRequestAuthorization(type: .notification)
                return
            }
        }
    }

    private func showAlreadyAllowed(type: Authorization) {
        let alertController = UIAlertController(title: type.rawValue, message: "이미 동의하셨습니다.", preferredStyle: .alert)
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
        let alertController = UIAlertController(title: type.rawValue, message: "앱 설정에서 \(type.rawValue)을 허용해주세요.", preferredStyle: .alert)
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

// extension ProfileViewController: UNUserNotificationCenterDelegate {
//    func userNotificationCenter(_ center: UNUserNotificationCenter,
//                                didReceive response: UNNotificationResponse,
//                                withCompletionHandler completionHandler: @escaping () -> Void) {
//        completionHandler()
//    }
//
//    func userNotificationCenter(_ center: UNUserNotificationCenter,
//                                willPresent notification: UNNotification,
//                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//        completionHandler([.badge, .sound, .banner])
//    }
// }
