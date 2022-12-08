//
//  CapsuleSettingsViewController.swift
//  SpaceCapsule
//
//  Created by jisu on 2022/12/07.
//

import UIKit
import RxSwift
import SnapKit

final class CapsuleSettingsViewController: UIViewController, BaseViewController {
    var disposeBag = DisposeBag()
    var viewModel: CapsuleSettingsViewModel?
    let settingsView = CapsuleSettingsView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .themeBackground
        addSubviews()
        makeConstraints()
        bind()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if let sheetPresentationController {
            let stackViewHeight = self.settingsView.mainStackView.frame.height
            
            sheetPresentationController.detents = [.custom { _ in
                return CGFloat(stackViewHeight + FrameResource.detailSettingButtonPadding * 2)
            }]
            
            sheetPresentationController.prefersGrabberVisible = true
        }
    }
    
    private func addSubviews() {
        view.addSubview(settingsView)
    }
    
    private func makeConstraints() {
        settingsView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func bind() {
        settingsView.deleteButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.presentDeleteAlert()
            })
            .disposed(by: disposeBag)
    }
    
    private func presentDeleteAlert() {
        let alertController = UIAlertController(
            title: "캡슐을 삭제 하시겠습니까?",
            message: "삭제된 캡슐은 다시 복구할 수 없습니다.",
            preferredStyle: .alert
        )

        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { [weak self] _ in
            self?.viewModel?.input.tapDelete.accept(())
        }

        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)

        present(alertController, animated: true, completion: nil)
    }
}
