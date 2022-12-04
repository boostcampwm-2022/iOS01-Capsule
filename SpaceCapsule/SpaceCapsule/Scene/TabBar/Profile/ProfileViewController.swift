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
            //self.viewModel?.withdrawal()
        })
        alertController.addAction(cancelAction)
        alertController.addAction(acceptAction)
        present(alertController, animated: true, completion: nil)
    }
}
