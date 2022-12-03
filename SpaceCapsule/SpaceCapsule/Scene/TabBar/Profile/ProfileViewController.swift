//
//  ProfileViewController.swift
//  SpaceCapsule
//
//  Created by young june Park on 2022/11/15.
//

import RxSwift
import RxCocoa
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
//        guard let viewModel else {
//            return
//        }
        profileView.settingButton.rx.tap
            .bind {
            print("setting")
        }
        .disposed(by: disposeBag)
        profileView.logOutButton.rx.tap
            .bind {
            print("log2")
        }
        .disposed(by: disposeBag)
        profileView.signOutButton.rx.tap
            .bind {
            print("signout")
        }
        .disposed(by: disposeBag)
    }
}
