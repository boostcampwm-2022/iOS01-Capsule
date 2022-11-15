//
//  NicknameView.swift
//  SpaceCapsule
//
//  Created by young june Park on 2022/11/15.
//

import SnapKit
import UIKit

final class NicknameView: UIView, BaseView {
    let nicknameLabel: UILabel = {
        let label = UILabel()
        label.text = "닉네임"
        label.font = .themeFont(ofSize: 20)
        label.textColor = .themeGray300

        return label
    }()

    let nicknameTextField: UITextField = {
        let textField = UITextField()
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.themeGray300?.cgColor
        textField.layer.cornerRadius = 10
        textField.font = .themeFont(ofSize: 20)

        textField.backgroundColor = .themeGray100

        return textField
    }()

    let doneButton: UIButton = {
        let button = UIButton()
        button.setTitle("완료", for: .normal)
        button.titleLabel?.font = .themeFont(ofSize: 20)
        button.backgroundColor = .themeColor200
        button.layer.cornerRadius = 10

        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        configure()
        addSubViews()
        makeConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure() {
        backgroundColor = .themeBackground
    }

    func addSubViews() {
        [nicknameLabel, nicknameTextField, doneButton].forEach {
            addSubview($0)
        }
    }

    func makeConstraints() {
        nicknameTextField.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(50)
        }

        nicknameLabel.snp.makeConstraints {
            $0.bottom.equalTo(nicknameTextField.snp.top).offset(-10)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        }

        doneButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.bottom.equalToSuperview().multipliedBy(0.9)
            $0.height.equalTo(50)
        }
    }
}
