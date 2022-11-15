//
//  NicknameViewController.swift
//  SpaceCapsule
//
//  Created by young june Park on 2022/11/15.
//

import RxSwift
import UIKit

final class NicknameViewController: UIViewController, BaseViewController {
    var disposeBag = DisposeBag()
    var viewModel: NickNameViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        view = NicknameView()
        bind()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

//        viewModel?.coordinator?.parent?.children.popLast()
    }

    func bind() {
        guard let nicknameView = view as? NicknameView,
              let viewModel else {
            // TODO: 예외처리
            return
        }

        nicknameView
            .nicknameTextField.rx.text
            .orEmpty
            .bind(to: viewModel.input.nickname)
            .disposed(by: disposeBag)

        nicknameView
            .doneButton.rx.tap
            .bind(to: viewModel.input.doneButtonTapped)
            .disposed(by: disposeBag)

        viewModel.input
            .doneButtonTapped
            .bind(onNext: {
            })
            .disposed(by: disposeBag)
    }
}
