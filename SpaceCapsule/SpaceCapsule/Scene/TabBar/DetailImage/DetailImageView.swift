//
//  DetailImageView.swift
//  SpaceCapsule
//
//  Created by 장재훈 on 2022/12/06.
//

import SnapKit
import UIKit

final class DetailImageView: UIView, BaseView {
    lazy var collectionView = UICollectionView(
        frame: self.frame,
        collectionViewLayout: self.collectionViewLayout()
    )

    let closeButton: UIButton = {
        let button = UIButton()
        button.setImage(.close, for: .normal)
        button.tintColor = .white

        return button
    }()

    let indexLabel = ThemeLabel(size: FrameResource.fontSize100, color: .white)

    var currentIndex: Int? {
        didSet {
            if let currentIndex, let itemCount {
                indexLabel.text = "\(currentIndex + 1) / \(itemCount)"
            }
        }
    }

    var itemCount: Int?

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
        collectionView.backgroundColor = .clear
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.alwaysBounceHorizontal = false
        collectionView.alwaysBounceVertical = false

        backgroundColor = .themeBlack
    }

    func addSubViews() {
        [collectionView, closeButton, indexLabel].forEach {
            addSubview($0)
        }
    }

    func makeConstraints() {
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        closeButton.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.leading.equalToSuperview().offset(FrameResource.horizontalPadding)
            $0.width.height.equalTo(FrameResource.closedIconSize)
        }

        indexLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(closeButton.snp.centerY)
        }
    }
}

extension DetailImageView {
    private func collectionViewLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        section.visibleItemsInvalidationHandler = { [weak self] _, offset, _ in
            let index = Int(offset.x / (self?.bounds.width ?? 1))

            if self?.currentIndex != index {
                self?.currentIndex = index
            }
        }

        let layout = UICollectionViewCompositionalLayout(section: section)

        return layout
    }
}
