//
//  EmptyView.swift
//  SpaceCapsule
//
//  Created by 장재훈 on 2022/12/07.
//

import SnapKit
import UIKit

final class EmptyView: UIView, BaseView {
    override init(frame: CGRect) {
        super.init(frame: frame)

        configure()
        addSubViews()
        makeConstraints()
    }

    private let imageView: UIImageView = {
        let imageView = UIImageView(image: .empty)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = FrameResource.emptyCapsuleWidth / 2
        imageView.clipsToBounds = true

        return imageView
    }()

    private let container: UIView = {
        let view = UIView()
        view.layer.shadowOffset = FrameResource.shadowOffset
        view.layer.shadowRadius = FrameResource.shadowRadius
        view.layer.shadowOpacity = FrameResource.shadowOpacity
        view.layer.cornerRadius = FrameResource.emptyCapsuleWidth / 2

        return view
    }()

    private let label: ThemeLabel = {
        let label = ThemeLabel(size: FrameResource.fontSize100, color: .themeGray400)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = """
        아직 추가한 캡슐이 없습니다.
        + 버튼을 눌러 캡슐을 추가해보세요!
        """

        return label
    }()

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure() {
        backgroundColor = .themeBackground
    }

    func addSubViews() {
        container.addSubview(imageView)

        [container, label].forEach {
            addSubview($0)
        }
    }

    func makeConstraints() {
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        container.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-FrameResource.bottomPadding)
            $0.width.equalTo(FrameResource.emptyCapsuleWidth)
            $0.height.equalTo(FrameResource.emptyCapsuleHeight)
        }

        label.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(container.snp.bottom).offset(FrameResource.spacing200)
        }
    }
}
