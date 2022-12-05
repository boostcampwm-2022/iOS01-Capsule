//
//  ProfileViewController.swift
//  SpaceCapsule
//
//  Created by young june Park on 2022/11/15.
//

import RxCocoa
import RxSwift
import UIKit

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
    }

    func bind() {
        guard let viewModel else {
            return
        }
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

        profileView.withdrawalButton.rx.tap
            .bind {
                viewModel.input.tapWithdrawal.onNext(())
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
            showRequestAuthorization()
        case .notDetermined, .restricted:
            AppDataManager.shared.location.core.requestWhenInUseAuthorization()
        default:
            showAlreadyAllowed()
            return
        }
    }

    private func showAlreadyAllowed() {
        let alertController = UIAlertController(title: "위치 권한", message: "이미 동의하셨습니다.", preferredStyle: .alert)
        let acceptAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        alertController.addAction(acceptAction)
        present(alertController, animated: true, completion: nil)
    }

    private func showRequestAuthorization() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        let alertController = UIAlertController(title: "위치 권한", message: "앱 설정에서 위치권한을 허용해주세요.", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let acceptAction = UIAlertAction(title: "OK", style: .default, handler: { _ in
            UIApplication.shared.open(url)
        })
        alertController.addAction(cancelAction)
        alertController.addAction(acceptAction)
        present(alertController, animated: true, completion: nil)
    }
}
