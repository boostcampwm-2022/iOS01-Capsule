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
    lazy var logoWithTextView: UIView = {
        var imageView = UIImageView()
        imageView.image = UIImage.logoWithText
        return imageView
    }()
        
    lazy var appleSignInButton: ASAuthorizationAppleIDButton = {
        var appleIDButton: ASAuthorizationAppleIDButton = ASAuthorizationAppleIDButton(type: .signIn, style: .black)
        return appleIDButton
    }()
    
    // MARK: - Lifecycles
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
        backgroundColor = .themeColor100
    }
    
    func addSubViews() {
        [logoWithTextView, appleSignInButton].forEach {
            addSubview($0)
        }
    }
    
    func makeConstraints() {
        logoWithTextView.snp.makeConstraints {
            $0.width.height.equalTo(FrameResource.logoWithTextSize)
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        
        appleSignInButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(FrameResource.signInButtonPadding)
            $0.trailing.equalToSuperview().offset(-FrameResource.signInButtonPadding)
            $0.bottom.equalToSuperview().offset(-FrameResource.bottomPadding)
            $0.height.equalTo(FrameResource.buttonHeight)
        }
    }
}
