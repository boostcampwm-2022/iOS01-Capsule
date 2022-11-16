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

    var disposeBag = DisposeBag()
    var viewModel: CapsuleCreateViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .themeBackground

        navigationItem.leftBarButtonItem = closeButton
        
        bind()
    }

    func bind() {
        guard let viewModel else { return }

        closeButton.rx.tap
            .bind(to: viewModel.input.close)
            .disposed(by: disposeBag)
    }
}
