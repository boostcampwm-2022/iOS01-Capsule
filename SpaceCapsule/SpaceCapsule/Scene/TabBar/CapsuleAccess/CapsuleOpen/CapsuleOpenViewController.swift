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
        bind()
        if let capsuleCellModel = viewModel?.capsuleCellModel {
            viewModel?.input.capsuleCellModel.onNext(capsuleCellModel)
        }
        viewModel?.output.isOpenable.onNext(false)
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
        guard let viewModel = self.viewModel else {
            // TODO: 예외처리
            return
        }
        capsuleOpenView.openButton.rx.tap
            .bind {
                viewModel.input.openButtonTapped.onNext(())
            }
            .disposed(by: disposeBag)
        
        viewModel.input.capsuleCellModel
            .withUnretained(self)
            .bind { owner, capsuleCellModel in
                owner.capsuleOpenView.configure(capsuleCellModel: capsuleCellModel)
            }.disposed(by: disposeBag)
        
        viewModel.input.openButtonTapped
            .withLatestFrom(viewModel.output.isOpenable)
            .withUnretained(self)
            .bind { weakSelf, isOpenable in
                if isOpenable {
                    // 애니메이션 적용과
                    // 진동
                    weakSelf.capsuleOpenView.shakeAnimate()
                    weakSelf.moveToCapsuleDetail()
                } else {
                    weakSelf.showAlert()
                }
            }
            .disposed(by: disposeBag)
        
        viewModel.output.isOpenable
            .subscribe(on: MainScheduler.instance)
            .withLatestFrom(viewModel.input.capsuleCellModel, resultSelector: { isOpenable, capsuleCellModel in
                if isOpenable == false {
                    self.capsuleOpenView.applyUnOpenableEffect(capsuleCellModel: capsuleCellModel)
                }
            })
            .bind(onNext: {})
            .disposed(by: disposeBag)
    
    }
    
    private func moveToCapsuleDetail() {
        print("move to CapsuleDetail 화면")
        // viewModel?.coordinator?.moveToCapsuleDetail()
    }
    
    private func showAlert() {
        let alertController = UIAlertController(title: "캡슐 알림", message: "열 수 없는 캡슐입니다", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let acceptAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(cancelAction)
        alertController.addAction(acceptAction)
        present(alertController, animated: true, completion: nil)
    }
    
}
