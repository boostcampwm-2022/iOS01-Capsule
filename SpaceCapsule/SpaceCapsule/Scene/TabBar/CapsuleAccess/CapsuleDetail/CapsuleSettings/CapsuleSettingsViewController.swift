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
                self?.viewModel?.input.tapDelete.accept(())
            })
            .disposed(by: disposeBag)
        
        viewModel?.output.uuid
            .subscribe(onNext: { [weak self] uuid in
                // 삭제하시겠습니까?
            })
            .disposed(by: disposeBag)
    }
}
