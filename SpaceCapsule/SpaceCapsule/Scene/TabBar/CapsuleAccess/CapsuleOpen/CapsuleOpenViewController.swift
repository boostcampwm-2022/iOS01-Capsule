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
        if let capsuleCellModel = viewModel?.capsuleCellModel {
            capsuleOpenView.configure(capsuleCellModel: capsuleCellModel)
        }
        bind()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        capsuleOpenView.animate()
    }

    override func viewWillDisappear(_ animated: Bool) {
        viewModel?.input.popViewController.onNext(())
        super.viewWillDisappear(animated)
    }

    func bind() {
        guard let viewModel = viewModel else {
            // TODO: 예외처리
            return
        }

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
        guard let capsuleCellModel = viewModel?.capsuleCellModel else {
            return
        }
        if capsuleCellModel.isOpenable() {
            capsuleOpenView.shakeAnimate()
            viewModel?.coordinator?.moveToCapsuleDetail()
        } else {
            showAlert()
        }
    }
}
