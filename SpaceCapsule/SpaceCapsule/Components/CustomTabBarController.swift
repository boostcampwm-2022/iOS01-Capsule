//
//  CustomTabBarController.swift
//  SpaceCapsule
//
//  Created by 장재훈 on 2022/11/16.
//

import RxCocoa
import RxSwift
import SnapKit
import UIKit

// TODO: - add final keyword
class CustomTabBarController: UITabBarController {
    let disposeBag = DisposeBag()
    var coordinator: TabBarCoordinator?

    lazy var centerButton: UIButton = {
        let button = UIButton()
        button.frame.size = CGSize(
            width: FrameResource.addCapsuleButtonSize,
            height: FrameResource.addCapsuleButtonSize
        )

        button.setImage(.addCapsuleFill, for: .normal)
        button.backgroundColor = .themeColor200
        button.tintColor = .white
        button.layer.cornerRadius = FrameResource.addCapsuleButtonSize / 2

        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        bindCenterButton()
        configureAppearance()
    }

    private func configureAppearance() {
        tabBar.backgroundColor = .white
        tabBar.tintColor = .themeColor300
        tabBar.unselectedItemTintColor = .themeGray200

        UITabBarItem.appearance().setTitleTextAttributes([.font: UIFont.themeFont(ofSize: 13)], for: .normal)
    }

    private func bindCenterButton() {
        centerButton.rx.tap
            .withUnretained(self)
            .bind { _ in self.coordinator?.moveToCapsuleAdd() }
            .disposed(by: disposeBag)
    }

    func setUpCenterButton() {
        tabBar.addSubview(centerButton)

        centerButton.snp.makeConstraints {
            $0.centerX.equalTo(tabBar.snp.centerX)
            $0.centerY.equalTo(tabBar.snp.top)
            $0.width.equalTo(FrameResource.addCapsuleButtonSize)
            $0.height.equalTo(FrameResource.addCapsuleButtonSize)
        }
    }
}
