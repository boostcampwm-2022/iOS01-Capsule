//
//  ProfileView.swift
//  SpaceCapsule
//
//  Created by young june Park on 2022/11/15.
//

import SnapKit
import UIKit

final class ProfileView: UIView, BaseView {
    lazy var profileImageView = {
        let profileImageView = UIImageView()
        profileImageView.contentMode = .scaleAspectFit
        profileImageView.layer.cornerRadius = FrameResource.profileImageWidth / 2
        profileImageView.clipsToBounds = true
        return profileImageView
    }()

    lazy var nicknameLabel = {
        let nicknameLabel = ThemeLabel(size: FrameResource.fontSize120, color: .themeBlack)
        return nicknameLabel
    }()

    lazy var topline = {
        let line = UIView()
        line.layer.borderWidth = FrameResource.commonBorderWidth
        line.layer.borderColor = UIColor.themeGray400?.cgColor
        return line
    }()

    lazy var bottomline = {
        let line = UIView()
        line.layer.borderWidth = FrameResource.commonBorderWidth
        line.layer.borderColor = UIColor.themeGray400?.cgColor
        return line
    }()

    lazy var stackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()

    lazy var notificationButton = {
        let notificationButton = ProfileButton(text: "알림 설정")
        return notificationButton
    }()

    lazy var settingButton = {
        let settingButton = ProfileButton(text: "위치정보 설정")
        return settingButton
    }()

    lazy var signOutButton = {
        let logOutButton = ProfileButton(text: "로그아웃")
        return logOutButton
    }()

    lazy var withdrawalButton = {
        let withdrawalButton = ProfileButton(text: "회원 탈퇴")
        return withdrawalButton
    }()

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
        profileImageView.image = .logo
        if let nickname = UserDefaultsManager<UserInfo>.loadData(key: .userInfo)?.nickname {
            nicknameLabel.text = nickname
        }
    }

    func addSubViews() {
        [notificationButton, settingButton, signOutButton, withdrawalButton].forEach {
            stackView.addArrangedSubview($0)
        }
        [profileImageView, nicknameLabel, stackView, topline, bottomline].forEach {
            addSubview($0)
        }
    }

    func makeConstraints() {
        profileImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(safeAreaLayoutGuide.snp.top).offset(FrameResource.bottomPadding)
            $0.height.width.equalTo(FrameResource.profileImageWidth)
        }

        nicknameLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(profileImageView.snp.bottom).offset(FrameResource.verticalPadding)
        }

        topline.snp.makeConstraints {
            $0.top.equalTo(nicknameLabel.snp.bottom).offset(FrameResource.verticalPadding)
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
}

