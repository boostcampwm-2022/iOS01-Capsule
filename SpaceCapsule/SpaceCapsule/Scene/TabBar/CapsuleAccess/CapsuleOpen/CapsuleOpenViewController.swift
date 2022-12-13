//
//  CapsuleOpenViewController.swift
//  SpaceCapsule
//
//  Created by young june Park on 2022/11/15.
//

import RxCocoa
import RxSwift
import UIKit

final class CapsuleOpenViewController: UIViewController, BaseViewController {
    var disposeBag = DisposeBag()
    var viewModel: CapsuleOpenViewModel?
    let capsuleOpenView = CapsuleOpenView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view = capsuleOpenView

        if let capsuleCellItem = viewModel?.capsuleCellItem {
            capsuleOpenView.configure(capsuleCellItem: capsuleCellItem)
        }

        bind()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel?.input.viewWillAppear.onNext(())
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        capsuleOpenView.animate()
    }

    override func viewDidDisappear(_ animated: Bool) {
        viewModel?.input.viewDidDisappear.onNext(())
        super.viewDidDisappear(animated)
    }

    func bind() {
        capsuleOpenView.openButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                owner.handleOpenButtonTap()
            }
            .disposed(by: disposeBag)
    }

    func handleOpenButtonTap() {
        guard let capsuleCellItem = viewModel?.capsuleCellItem else {
            return
        }
        
        if capsuleCellItem.isOpenable() {
            viewModel?.input.tapOpen.onNext(())
        } else {
            capsuleOpenView.shakeAnimate()
        }
    }
}
