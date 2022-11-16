//
//  CustomTabBarController.swift
//  SpaceCapsule
//
//  Created by 장재훈 on 2022/11/16.
//

import SnapKit
import UIKit

// TODO: - add final keyword
class CustomTabBarController: UITabBarController, UITabBarControllerDelegate {
    private let centerButtonView: UIImageView = {
        let imageView = UIImageView(image: .addCapsuleFill)
        imageView.tintColor = .themeColor200

        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        delegate = self

        configureAppearance()
//        setUpCenterButton()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let location = touches.first?.location(in: view) {
            print(location)
            print(centerButtonView.frame)
        }
    }

    private func configureAppearance() {
        tabBar.backgroundColor = .white
        tabBar.tintColor = .themeColor300
        tabBar.unselectedItemTintColor = .themeGray200

        UITabBarItem.appearance().setTitleTextAttributes([.font: UIFont.themeFont(ofSize: 13)], for: .normal)
    }

    

    @objc private func tappedCenterButton(_ gesture: UITapGestureRecognizer) {
        print("Hello!!")
    }
}
