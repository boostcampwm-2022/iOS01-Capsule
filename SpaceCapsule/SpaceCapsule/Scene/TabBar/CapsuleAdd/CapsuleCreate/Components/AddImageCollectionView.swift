//
//  AddImageCollectionView.swift
//  SpaceCapsule
//
//  Created by 장재훈 on 2022/11/19.
//

import UIKit

final class AddImageCollectionView: UICollectionView {
    enum Cell: Hashable {
        case image(data: String)
        case addButton
        
        var data: String? {
            switch self {
            case .image(let data):
                return data
            case .addButton:
                return nil
            }
        }
    }
    
    required init(frame: CGRect) {
        super.init(frame: frame, collectionViewLayout: AddImageCollectionView.layout())
        
        register(
            AddImageCell.self,
            forCellWithReuseIdentifier: AddImageCell.identifier
        )
        
        register(
            AddImageButtonCell.self,
            forCellWithReuseIdentifier: AddImageButtonCell.identifier
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

        let footerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalHeight(1),
            heightDimension: .fractionalHeight(1)
        )
        let footer = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: footerSize,
            elementKind: UICollectionView.elementKindSectionFooter,
            alignment: .bottom
        )

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        section.interGroupSpacing = 20
        section.boundarySupplementaryItems = [footer]

        let layout = UICollectionViewCompositionalLayout(section: section)

        return layout
    }
}
