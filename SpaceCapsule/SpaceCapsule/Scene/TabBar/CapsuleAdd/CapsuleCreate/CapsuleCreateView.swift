//
//  CapsuleCreateView.swift
//  SpaceCapsule
//
//  Created by young june Park on 2022/11/15.
//

import SnapKit
import UIKit

final class CapsuleCreateCollectionViewCell: UICollectionViewCell {
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill

        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubViews()
        makeConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(item: String) {
        imageView.image = UIImage(named: item)
    }

    private func addSubViews() {
        addSubview(imageView)
    }

    private func makeConstraints() {
        imageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
        }
    }
}

final class CapsuleCreateCollectionView: UICollectionView {
    required init(frame: CGRect) {
        super.init(frame: frame, collectionViewLayout: CapsuleCreateCollectionView.layout())

        register(
            CapsuleCreateCollectionViewCell.self,
            forCellWithReuseIdentifier: CapsuleCreateCollectionViewCell.identifier
        )
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private static func layout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalHeight(1),
            heightDimension: .fractionalHeight(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalHeight(1),
            heightDimension: .fractionalHeight(1)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        section.interGroupSpacing = 20

        let layout = UICollectionViewCompositionalLayout(section: section)

        return layout
    }
}

final class CapsuleCreateView: UIView, BaseView {
    private let mainStackView = UIStackView()
    private let inputStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical

        return stackView
    }()

    let titleLabel = ThemeLabel(text: "캡슐 이름", size: FrameResource.fontSize100, color: .themeGray300)
    let locationLabel = ThemeLabel(text: "위치", size: FrameResource.fontSize100, color: .themeGray300)
    let dateLabel = ThemeLabel(text: "추억 날짜", size: FrameResource.fontSize100, color: .themeGray300)
    let descriptionLabel = ThemeLabel(text: "내용", size: FrameResource.fontSize100, color: .themeGray300)

    let titleTextField = ThemeTextField()

    lazy var imageCollectionView = CapsuleCreateCollectionView(frame: frame)
    private let sampleImages: [UIImage?] = [.logoWithBG, .logoWithText, .logo]

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

    func configure() {
        backgroundColor = .themeBackground
    }

    func addSubViews() {
        [
            imageCollectionView,
            titleLabel,
            titleTextField,
            locationLabel,
            dateLabel,
            descriptionLabel,
        ].forEach {
            inputStackView.addArrangedSubview($0)
        }

        addSubview(inputStackView)
    }

    func makeConstraints() {
        imageCollectionView.snp.makeConstraints {
            $0.height.equalTo(250)
        }

        inputStackView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
        }

        titleTextField.snp.makeConstraints {
            $0.height.equalTo(FrameResource.textFieldHeight)
        }
    }
}

#if canImport(SwiftUI) && DEBUG
    import SwiftUI
    struct CapsuleCreateViewPreview: PreviewProvider {
        static var previews: some View {
            UIViewPreview {
                CapsuleCreateView()
            }
            .previewLayout(.sizeThatFits)
        }
    }
#endif
