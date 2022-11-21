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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = capsuleCloseView
        bind()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        capsuleCloseView.animate()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        viewModel?.input.popViewController.onNext(())
        super.viewWillDisappear(animated)
    }

    func bind() {
        guard let viewModel = self.viewModel else {
            // TODO: 예외처리
            return
        }
        capsuleCloseView.closeButton.rx.tap
            .bind {
                viewModel.input.closeButtonTapped.onNext(())
            }
            .disposed(by: disposeBag)
        
        viewModel.input.closeButtonTapped
            .withUnretained(self)
            .bind { weakSelf in
                print("close button tapped")
            }
            .disposed(by: disposeBag)
    }
}
