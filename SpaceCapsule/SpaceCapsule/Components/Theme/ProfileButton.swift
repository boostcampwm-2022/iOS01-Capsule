//
//  ProfileButton.swift
//  SpaceCapsule
//
//  Created by young june Park on 2022/12/03.
//

import SnapKit
import UIKit

class ProfileButton: UIControl {
    private let label = ThemeLabel(size: FrameResource.fontSize100, color: .themeGray400)
    private let icon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .chevronRight
        imageView.tintColor = .themeGray400

        return imageView
    }()

    convenience init(text: String) {
        self.init()
        isUserInteractionEnabled = true
        label.text = text
        backgroundColor = .themeBackground
        addSubViews()
        makeConstraints()
    }

    func setText(_ text: String) {
        label.text = text
    }

    private func addSubViews() {
        [label, icon].forEach {
            addSubview($0)
        }
    }

    private func makeConstraints() {
        snp.makeConstraints {
            $0.height.equalTo(FrameResource.profileButtonHeight)
        }

        label.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(10)
        }

        icon.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-10)
            $0.leading.greaterThanOrEqualTo(label).offset(10)
        }
    }
}

