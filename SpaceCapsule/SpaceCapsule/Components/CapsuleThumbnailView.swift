//
//  CapsuleOpenCloseView.swift
//  SpaceCapsule
//
//  Created by 장재훈 on 2022/12/12.
//

import AVFoundation
import SnapKit
import UIKit

class CapsuleThumbnailView: UIView {
    struct Item {
        let thumbnailImageURL: String
        let closedDateString: String
        let memoryDateString: String
        let simpleAddress: String
    }

    let thumbnailImageView = ThumbnailImageView(
        frame: .zero,
        width: UIScreen.main.bounds.width * FrameResource.capsuleThumbnailWidthRatio
    )

    let descriptionLabel = {
        let label = ThemeLabel(size: FrameResource.fontSize140, color: .themeGray300)
        label.numberOfLines = 3
        label.textAlignment = .center

        return label
    }()

    let bottomButton = ThemeButton(title: " ")

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

    func configure(item: Item) {
        descriptionLabel.asFontColor(
            targetStringList: [item.memoryDateString, item.simpleAddress],
            size: FrameResource.fontSize140,
            color: .themeGray400
        )

        thumbnailImageView.imageView.kr.setImage(
            with: item.thumbnailImageURL,
            placeholder: .empty,
            scale: FrameResource.closedImageScale
        )
    }

    func addSubViews() {
        [thumbnailImageView, descriptionLabel, bottomButton].forEach {
            addSubview($0)
        }
    }

    func makeConstraints() {
        thumbnailImageView.snp.remakeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().multipliedBy(AnimationResource.fromOriginY)
            $0.width.equalTo(UIScreen.main.bounds.width * FrameResource.capsuleThumbnailWidthRatio)
            $0.height.equalTo(UIScreen.main.bounds.width * FrameResource.capsuleThumbnailWidthRatio * FrameResource.capsuleThumbnailHWRatio)
        }

        descriptionLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(self.snp.centerY).multipliedBy(0.7)
                .offset(FrameResource.capsuleThumbnailHeight / 2 + AnimationResource.capsuleMoveHeight)
            $0.bottom.equalTo(bottomButton.snp.top).offset(-FrameResource.spacing200).priority(999)
        }

        bottomButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(FrameResource.horizontalPadding)
            $0.trailing.equalToSuperview().offset(-FrameResource.horizontalPadding)
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-FrameResource.spacing200)
            $0.height.equalTo(FrameResource.buttonHeight)
        }
    }

    func animate() {
        UIView.animate(withDuration: AnimationResource.capsuleMoveDuration, animations: {
            self.layoutIfNeeded()
            self.thumbnailImageView.center.y = (self.frame.height * AnimationResource.destinationHeightRatio)
        }, completion: { _ in
            UIView.animate(
                withDuration: AnimationResource.capsuleMoveDuration,
                delay: 0,
                options: [.repeat, .autoreverse]
            ) {
                self.thumbnailImageView.transform = .init(translationX: 0, y: AnimationResource.capsuleMoveHeight)
            }
        })
    }
}
