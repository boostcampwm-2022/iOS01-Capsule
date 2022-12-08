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

    private func showAlert() {
        let alertController = UIAlertController(title: "캡슐 알림", message: "열 수 없는 캡슐입니다", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let acceptAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(cancelAction)
        alertController.addAction(acceptAction)
        present(alertController, animated: true, completion: nil)
    }

    func handleOpenButtonTap() {
        guard let capsuleCellItem = viewModel?.capsuleCellItem else {
            return
        }
        if capsuleCellItem.isOpenable() {
            capsuleOpenView.shakeAnimate()
            viewModel?.input.tapOpen.onNext(())
        } else {
            showAlert()
        }
    }
}
