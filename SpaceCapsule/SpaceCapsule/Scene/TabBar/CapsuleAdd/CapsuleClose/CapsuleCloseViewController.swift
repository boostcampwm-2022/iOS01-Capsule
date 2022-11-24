//
//  CapsuleCloseViewController.swift
//  SpaceCapsule
//
//  Created by young june Park on 2022/11/15.
//

import RxCocoa
import RxSwift
import UIKit

final class CapsuleCloseViewController: UIViewController, BaseViewController {
    var disposeBag = DisposeBag()
    var viewModel: CapsuleCloseViewModel?
    let capsuleCloseView = CapsuleCloseView()

    override func loadView() {
        view = capsuleCloseView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        bind()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        capsuleCloseView.animate()
    }

    func bind() {
        capsuleCloseView.closeButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.viewModel?.input.closeButtonTapped.onNext(())
            })
            .disposed(by: disposeBag)
    }
}
