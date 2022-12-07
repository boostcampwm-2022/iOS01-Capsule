//
//  CapsuleSettingsView.swift
//  SpaceCapsule
//
//  Created by jisu on 2022/12/07.
//

import UIKit
import SnapKit

final class CapsuleSettingsView: UIView, BaseView {
    let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.backgroundColor = .themeGray400
        stackView.spacing = 1
        
        return stackView
    }()

    lazy var deleteButton: SettingsButton = {
        let button = SettingsButton()
        button.setTitle("캡슐 삭제", for: .normal)
        button.setImage(.init(systemName: "trash"), for: .normal)

        return button
    }()
    
    lazy var modifierButton: SettingsButton = {
        let button = SettingsButton()
        button.setTitle("캡슐 수정", for: .normal)
        button.setImage(.init(systemName: "trash"), for: .normal)
        
        return button
    }()
    
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
    
    func configure() {}

    func addSubViews() {
        [deleteButton, modifierButton].forEach {
            mainStackView.addArrangedSubview($0)
        }
        
        self.addSubview(mainStackView)
    }

    func makeConstraints() {
        [deleteButton,
         modifierButton].forEach { subview in
            subview.snp.makeConstraints {
                $0.height.equalTo(FrameResource.detailSettingButtonHeight)
            }
        }
        
        mainStackView.snp.makeConstraints {
            $0.left.right.top.equalToSuperview().inset(FrameResource.detailSettingButtonPadding)
        }
    }
}

extension CapsuleSettingsView {
    final class SettingsButton: UIButton {
        let buttonConfiguration: UIButton.Configuration = {
            var configuration = UIButton.Configuration.plain()
            configuration.imagePadding = 10.0
            configuration.imagePlacement = .leading
            configuration.baseForegroundColor = .themeGray400
            
            return configuration
        }()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            configuration = buttonConfiguration
            titleLabel?.font = UIFont.themeFont(ofSize: 15)
            contentHorizontalAlignment = .left
            backgroundColor = .themeBackground
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}
