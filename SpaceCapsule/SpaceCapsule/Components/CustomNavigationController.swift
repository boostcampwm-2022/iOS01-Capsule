//
//  CustomNavigationController.swift
//  SpaceCapsule
//
//  Created by 장재훈 on 2022/11/25.
//

import UIKit

final class CustomNavigationController: UINavigationController {
    private let indicatorView = LoadingIndicatorView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        applyThemeStyle()
    }

    private func applyThemeStyle() {
        UIBarButtonItem.appearance().setTitleTextAttributes([.font: UIFont.themeFont(ofSize: 25) as Any], for: .normal)
        UIBarButtonItem.appearance().setTitleTextAttributes([.font: UIFont.themeFont(ofSize: 25) as Any], for: .disabled)
        UIBarButtonItem.appearance().setTitleTextAttributes([.font: UIFont.themeFont(ofSize: 25) as Any], for: .highlighted)

        navigationBar.titleTextAttributes = [.font: UIFont.themeFont(ofSize: 25) as Any]
        navigationBar.tintColor = .themeBlack
        navigationBar.topItem?.backButtonTitle = ""
    }

    func addIndicatorView() {
        view.addSubview(indicatorView)

        indicatorView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    func removeIndicatorView() {
        indicatorView.removeFromSuperview()
    }
}
