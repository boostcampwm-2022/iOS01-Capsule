//
//  SignInView.swift
//  SpaceCapsule
//
//  Created by young june Park on 2022/11/15.
//

import UIKit
import SnapKit
import AuthenticationServices

final class SignInView: UIView, BaseView {
    // MARK: - UIComponents
    
    lazy var appleSignInButton: ASAuthorizationAppleIDButton = {
        var appleIDButton: ASAuthorizationAppleIDButton = ASAuthorizationAppleIDButton(type: .signIn, style: .black)
        appleIDButton.layer.cornerRadius = 7
//        appleIDButton.clipsToBounds = true
        return appleIDButton
    }()
    
    // MARK: - Lifecycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        addSubViews()
        makeConstraints()
    }
    
    // TODO: 무슨 의미인가?
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    func configure() {
        backgroundColor = .themeBackground
    }
    
    func addSubViews() {
        [appleSignInButton].forEach {
            // MARK: translatesAutoresizingMaskIntoConstraints ??
//            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
    }
    
    func makeConstraints() {
        appleSignInButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(FrameResource.horizontalPadding)
            $0.trailing.equalToSuperview().offset(-FrameResource.horizontalPadding)
            $0.bottom.equalToSuperview().offset(-FrameResource.bottomPadding)
            $0.height.equalTo(FrameResource.buttonHeight)
        }
    }
}
