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
        profileView.notificationButton.rx.tap
            .bind { [weak self] in
                self?.viewModel?.input.tapSetupNotification.onNext(())
            }
            .disposed(by: disposeBag)

        profileView.settingButton.rx.tap
            .bind { [weak self] in
                self?.viewModel?.input.tapSetting.onNext(())
            }
            .disposed(by: disposeBag)

        profileView.signOutButton.rx.tap
            .bind { [weak self] in
                self?.viewModel?.input.tapSignOut.onNext(())
            }
            .disposed(by: disposeBag)

        profileView.deleteAccountButton.rx.tap
            .bind { [weak self] in
                self?.viewModel?.input.tapWithdrawal.onNext(())
            }
            .disposed(by: disposeBag)

        profileView.profileImageContainer.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.profileView.setUserImage()
            })
            .disposed(by: disposeBag)
    }

    func bindViewModel() {
        guard let viewModel else {
            return
        }

        viewModel.input.tapSetupNotification
            .withUnretained(self)
            .bind { owner, _ in
                owner.showSettings(type: UIApplication.openNotificationSettingsURLString)
            }
            .disposed(by: disposeBag)

        viewModel.input.tapSetting
            .withUnretained(self)
            .bind { owner, _ in
                owner.showSettings(type: UIApplication.openSettingsURLString)
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
    
    private func showSettings(type: String) {
        guard let url = URL(string: type) else {
            return 
        }
        
        UIApplication.shared.open(url)
    }
}
