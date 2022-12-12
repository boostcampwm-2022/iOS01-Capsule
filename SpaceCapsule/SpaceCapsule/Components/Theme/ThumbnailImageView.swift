//
//  ThemeThumbnailImageView.swift
//  SpaceCapsule
//
//  Created by 김민중 on 2022/11/29.
//

import UIKit

final class ThumbnailImageView: UIView {
    // MARK: - Properties

    let width: CGFloat

    // MARK: - UIComponents

    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = width / 2
        imageView.clipsToBounds = true
        imageView.backgroundColor = .white
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()

    // MARK: - Lifecycles

    init(frame: CGRect, width: CGFloat) {
        self.width = width
        print(width)
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

    private func configure() {
        backgroundColor = .themeGray100
        layer.shadowOffset = FrameResource.capsuleCellShadowOffset
        layer.shadowRadius = FrameResource.capsuleCellShadowRadius
        layer.shadowOpacity = FrameResource.capsuleCellShadowOpacity
        layer.cornerRadius = width / 2
    }

    private func addSubViews() {
        [imageView].forEach {
            addSubview($0)
        }
    }

    private func makeConstraints() {
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
