//
//  ProfileViewController.swift
//  SpaceCapsule
//
//  Created by young june Park on 2022/11/15.
//

import RxSwift
import UIKit

final class ProfileViewController: UIViewController, BaseViewController {
    var disposeBag = DisposeBag()
    var viewModel: ProfileViewModel?

    let mainView = ProfileView()

    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground

        bind()
    }

    func bind() {
        // 임시요
        mainView.deleteButton.rx.tap
            .subscribe { _ in
                self.viewModel?.input.tapDelete.onNext(())
            }
            .disposed(by: disposeBag)
    }
}
