//
//  ProfileView.swift
//  SpaceCapsule
//
//  Created by young june Park on 2022/11/15.
//

import SnapKit
import UIKit

final class ProfileView: UIView, BaseView {
    let profileImageContainer: UIControl = {
        let control = UIControl()
        control.backgroundColor = .themeGray200
        control.layer.cornerRadius = FrameResource.profileImageWidth / 2

        return control
    }()

    private let profileImageView = {
        let profileImageView = UIImageView()
        profileImageView.contentMode = .scaleAspectFit
        profileImageView.clipsToBounds = true

        return profileImageView
    }()

    private let nicknameLabel = ThemeLabel(size: FrameResource.fontSize120, color: .themeBlack)

    private let topline = {
        let line = UIView()
        line.layer.borderWidth = FrameResource.commonBorderWidth
        line.layer.borderColor = UIColor.themeGray400?.cgColor

        return line
    }()

    private let bottomline = {
        let line = UIView()
        line.layer.borderWidth = FrameResource.commonBorderWidth
        line.layer.borderColor = UIColor.themeGray400?.cgColor

        return line
    }()

    private let stackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()

    let notificationButton = ProfileButton(text: "알림 설정")
    let settingButton = ProfileButton(text: "위치정보 설정")
    let signOutButton = ProfileButton(text: "로그아웃")
    let deleteAccountButton = ProfileButton(text: "회원 탈퇴")

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .themeBackground

        configure()
        addSubViews()
        makeConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure() {
        setUserImage()

        if let nickname = UserDefaultsManager<UserInfo>.loadData(key: .userInfo)?.nickname {
            nicknameLabel.text = nickname
        }
    }

    func addSubViews() {
        profileImageContainer.addSubview(profileImageView)

        [notificationButton, settingButton, signOutButton, deleteAccountButton].forEach {
            stackView.addArrangedSubview($0)
        }

        [
            profileImageContainer,
            nicknameLabel,
            stackView,
            topline,
            bottomline,
        ].forEach {
            addSubview($0)
        }
    }

    func makeConstraints() {
        profileImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(FrameResource.horizontalPadding)
            $0.trailing.equalToSuperview().offset(-FrameResource.horizontalPadding)
            $0.top.equalToSuperview().offset(FrameResource.horizontalPadding)
            $0.bottom.equalToSuperview().offset(-FrameResource.horizontalPadding)
        }

        profileImageContainer.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(safeAreaLayoutGuide.snp.top).offset(FrameResource.bottomPadding)
            $0.height.width.equalTo(FrameResource.profileImageWidth)
        }

        nicknameLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(profileImageContainer.snp.bottom).offset(FrameResource.verticalPadding)
        }

        topline.snp.makeConstraints {
            $0.top.equalTo(nicknameLabel.snp.bottom).offset(FrameResource.bottomPadding)
            $0.leading.equalToSuperview().offset(FrameResource.horizontalPadding)
            $0.trailing.equalToSuperview().offset(-FrameResource.horizontalPadding)
            $0.height.equalTo(FrameResource.commonBorderWidth)
        }

        stackView.snp.makeConstraints {
            $0.top.equalTo(topline.snp.bottom).offset(FrameResource.verticalPadding)
            $0.leading.equalToSuperview().offset(FrameResource.horizontalPadding)
            $0.trailing.equalToSuperview().offset(-FrameResource.horizontalPadding)
        }

        bottomline.snp.makeConstraints {
            $0.top.equalTo(stackView.snp.bottom).offset(FrameResource.verticalPadding)
            $0.leading.equalToSuperview().offset(FrameResource.horizontalPadding)
            $0.trailing.equalToSuperview().offset(-FrameResource.horizontalPadding)
            $0.height.equalTo(FrameResource.commonBorderWidth)
        }
    }

    func setUserImage() {
        profileImageView.image = ProfileResource.randomEmoji
    }
}
