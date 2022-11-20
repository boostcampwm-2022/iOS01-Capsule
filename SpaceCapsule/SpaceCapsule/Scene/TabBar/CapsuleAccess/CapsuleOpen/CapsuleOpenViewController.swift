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
    
    override func loadView() {
        view = capsuleOpenView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        viewModel?.output.isOpenable.onNext(true)
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
        
        viewModel.input.openButtonTapped
            .withLatestFrom(viewModel.output.isOpenable)
            .withUnretained(self)
            .bind { weakSelf, isOpenable in
                if isOpenable {
                    weakSelf.moveToCapsuleDetail()
                } else {
                    weakSelf.showAlert()
                }
            }
            .disposed(by: disposeBag)
        
        viewModel.output.isOpenable
            .subscribe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { weakSelf, isOpenable in
                print("unOpenable", isOpenable)
                if isOpenable == false {
                    weakSelf.capsuleOpenView.applyUnOpenableEffect()
                }
            })
            .disposed(by: disposeBag)
    
    }
    
    private func moveToCapsuleDetail() {
        print("moveToCapsuleDetail")
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
