//
//  SelectButton.swift
//  SpaceCapsule
//
//  Created by 장재훈 on 2022/11/21.
//

import SnapKit
import UIKit

class SelectButton: UIView {
    private let label = ThemeLabel(size: FrameResource.fontSize100, color: .themeGray400)
    private let icon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .triangleDown
        imageView.tintColor = .themeGray300

        return imageView
    }()

    var eventHandler: (() -> Void)?

    convenience init(text: String) {
        self.init()

        label.text = text
        backgroundColor = .themeGray100

        layer.borderColor = UIColor.themeGray300?.cgColor
        layer.borderWidth = FrameResource.commonBorderWidth
        layer.cornerRadius = FrameResource.commonCornerRadius

        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapGestureEvent(_:))))
        addSubViews()
        makeConstraints()
    }

    @objc private func tapGestureEvent(_ sender: UITapGestureRecognizer) {
        eventHandler?()
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
            $0.height.equalTo(FrameResource.textFieldHeight)
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
