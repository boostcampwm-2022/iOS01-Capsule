//
//  NicknameView.swift
//  SpaceCapsule
//
//  Created by young june Park on 2022/11/15.
//

import SnapKit
import UIKit

final class NicknameView: UIView, BaseView {
    let nicknameTextField: UITextField = {
       let textField = UITextField()
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.themeGray200?.cgColor
        
        return textField
    }()

    let doneButton: UIButton = {
        let button = UIButton()
        button.setTitle("완료", for: .normal)
        button.backgroundColor = .red

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
        [nicknameTextField, doneButton].forEach {
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

        doneButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.bottom.equalToSuperview().multipliedBy(0.9)
            $0.height.equalTo(50)
        }
    }
}
