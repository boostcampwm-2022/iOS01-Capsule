//
//  AddImageCollectionView.swift
//  SpaceCapsule
//
//  Created by 장재훈 on 2022/11/19.
//

import UIKit

final class AddImageCollectionView: UICollectionView {
    private var imageDataSource: UICollectionViewDiffableDataSource<Section, Item>?

    typealias Item = AddImageCollectionView.Cell

    private enum Section {
        case main
    }

    enum Cell: Hashable {
        case image(data: Data)
        case addButton

        var data: Data? {
            switch self {
            case let .image(data):
                return data
            case .addButton:
                return nil
            }
        }
    }

    required init(frame: CGRect) {
        super.init(frame: frame, collectionViewLayout: AddImageCollectionView.layout())

        backgroundColor = .clear

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

    func applyDataSource() {
        imageDataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: self, cellProvider: { collectionView, indexPath, item in

            switch item {
            case .image:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddImageCell.identifier, for: indexPath) as? AddImageCell,
                      let itemData = item.data else {
                    return UICollectionViewCell()
                }

                cell.configure(data: itemData)

                return cell

            case .addButton:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddImageButtonCell.identifier, for: indexPath) as? AddImageButtonCell else {
                    return UICollectionViewCell()
                }

                return cell
            }

        })
    }

    func applySnapshot(items: [AddImageCollectionView.Cell]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.main])
        snapshot.appendItems(items, toSection: .main)
        imageDataSource?.apply(snapshot)
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
