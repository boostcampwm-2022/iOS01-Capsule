//
//  CapsuleCloseView.swift
//  SpaceCapsule
//
//  Created by young june Park on 2022/11/15.
//

import SnapKit
import UIKit

final class CapsuleCloseView: CapsuleThumbnailView, BaseView, UnOpenable {
    let blurEffectView = CapsuleBlurEffectView(width: UIScreen.main.bounds.width * FrameResource.capsuleThumbnailWidthRatio)

    var lockImageView = {
        let lockImageView = UIImageView()
        lockImageView.image = .lock
        lockImageView.tintColor = .themeGray200
        return lockImageView
    }()

    var closedDateLabel = {
        let dateLabel = ThemeLabel(size: FrameResource.fontSize80, color: .themeGray200)
        dateLabel.textAlignment = .center
        dateLabel.numberOfLines = 0
        
        return dateLabel
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

    override func configure(item: Item) {
        bottomButton.setTitle("완료", for: .normal)
        
        descriptionLabel.text = """
        \(item.memoryDateString)
        \(item.simpleAddress) 에서의
        추억이 담긴 캡슐을 보관하였습니다.
        """
        
        closedDateLabel.text = "밀봉시간 \(item.closedDateString)"

        applyUnopenableEffect(superview: thumbnailImageView)

        super.configure(item: item)
    }
}
