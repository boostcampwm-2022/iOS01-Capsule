//
//  LoadingView.swift
//  SpaceCapsule
//
//  Created by 김민중 on 2022/11/21.
//

import UIKit
import SnapKit

final class LoadingView: UIView, BaseView {
    // MARK: - UIComponents
    lazy var logoWithTextView: UIView = {
        var imageView = UIImageView()
        imageView.image = UIImage.logoWithText
        return imageView
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
        [logoWithTextView].forEach {
            addSubview($0)
        }
    }
    
    func makeConstraints() {
        logoWithTextView.snp.makeConstraints {
            $0.width.height.equalTo(FrameResource.logoWithTextSize)
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
    }
}
