//
//  CapsuleCreateViewController.swift
//  SpaceCapsule
//
//  Created by young june Park on 2022/11/15.
//

import RxSwift
import UIKit

final class CapsuleCreateViewController: UIViewController, BaseViewController {
    private let closeButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.tintColor = .themeBlack
        button.image = .close

        return button
    }()

    private let doneButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.tintColor = .themeBlack
        button.title = "완료"

        return button
    }()

    var disposeBag = DisposeBag()
    var viewModel: CapsuleCreateViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .themeBackground

        bind()
        setUpNavigation()
    }

    func bind() {
        guard let viewModel else { return }

        closeButton.rx.tap
            .bind(to: viewModel.input.close)
            .disposed(by: disposeBag)
    }

    private func setUpNavigation() {
        navigationItem.title = "캡슐 추가"
        navigationItem.leftBarButtonItem = closeButton
        navigationItem.rightBarButtonItem = doneButton
    }
}
