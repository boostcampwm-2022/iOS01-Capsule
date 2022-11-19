//
//  NicknameView.swift
//  SpaceCapsule
//
//  Created by young june Park on 2022/11/15.
//

import SnapKit
import UIKit

final class NicknameView: UIView, BaseView {
    // MARK: - UIComponents

    let nicknameLabel = ThemeLabel(text: "닉네임", size: 20, color: .themeGray300)

    let nicknameTextField = ThemeTextField()

    let doneButton: UIButton = {
        let button = UIButton()
        button.setTitle("완료", for: .normal)
        button.titleLabel?.font = .themeFont(ofSize: 20)
        button.backgroundColor = .themeColor200
        button.layer.cornerRadius = 10

        return button
    }()

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)

        configure()
        addSubViews()
        makeConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

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
            $0.leading.equalToSuperview().offset(FrameResource.horizontalPadding)
            $0.trailing.equalToSuperview().offset(-FrameResource.horizontalPadding)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(FrameResource.textFieldHeight)
        }

        nicknameLabel.snp.makeConstraints {
            $0.bottom.equalTo(nicknameTextField.snp.top).offset(-10)
            $0.leading.equalToSuperview().offset(FrameResource.horizontalPadding)
            $0.trailing.equalToSuperview().offset(-FrameResource.horizontalPadding)
        }

        doneButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(FrameResource.horizontalPadding)
            $0.trailing.equalToSuperview().offset(-FrameResource.horizontalPadding)
            $0.bottom.equalToSuperview().offset(-FrameResource.bottomPadding)
            $0.height.equalTo(FrameResource.buttonHeight)
        }
    }
}

#if canImport(SwiftUI) && DEBUG
    import SwiftUI
    struct NicknameViewPreview: PreviewProvider {
        static var previews: some View {
            UIViewPreview {
                NicknameView()
            }
            .previewLayout(.sizeThatFits)
        }
    }
#endif
