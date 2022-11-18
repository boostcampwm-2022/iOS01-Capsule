//
//  CapsuleCreateView.swift
//  SpaceCapsule
//
//  Created by young june Park on 2022/11/15.
//

import SnapKit
import UIKit

final class CapsuleCreateCollectionViewCell: UICollectionViewCell { }

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
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalWidth(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.8),
            heightDimension: .fractionalWidth(0.8)
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
    private var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical

        return stackView
    }()
    
    private lazy var imageCollectionView = CapsuleCreateCollectionView(frame: frame)

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure() {
    }

    func addSubViews() {
    }

    func makeConstraints() {
    }
}
