//
//  ContentImageCollectionView.swift
//  SpaceCapsule
//
//  Created by jisu on 2022/11/29.
//

import SnapKit
import UIKit

final class DetailImageCollectionView: UICollectionView {
    private var imageDataSource: UICollectionViewDiffableDataSource<Int, String>?

    required init(frame: CGRect) {
        let customLayout = DetailImageFlowLayout()
        super.init(frame: frame, collectionViewLayout: customLayout)
        register(DetailImageCell.self, forCellWithReuseIdentifier: DetailImageCell.identifier)

        configure()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {
        alwaysBounceHorizontal = true
        backgroundColor = .clear
        showsHorizontalScrollIndicator = false
    }

    // MARK: DataSource

    enum Cell: Hashable {
        case image(data: Data)
        // TODO: 더미데이터 삭제 필요
        case sampleImage1
        case sampleImage2
        case sampleImage3
        case sampleImage4
        case sampleImage5
    }

    func applyDataSource() {
        imageDataSource = UICollectionViewDiffableDataSource<Int, String>(collectionView: self, cellProvider: { collectionView, indexPath, item in

            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailImageCell.identifier, for: indexPath) as? DetailImageCell else {
                return UICollectionViewCell()
            }
            
//            cell.configure()
            cell.imageView.kr.setImage(with: item, scale: 1.0)
            
            return cell
//            switch item {
//            case .image:
//                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailImageCell.identifier, for: indexPath) as? DetailImageCell else {
//                    return UICollectionViewCell()
//                }
//                return cell
//            default:
//                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailImageCell.identifier, for: indexPath) as? DetailImageCell else {
//                    return UICollectionViewCell()
//                }
//                cell.imageView.image = UIImage.logoWithBG
//                return cell
//            }
        })
    }

    func applySnapshot(items: [String]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, String>()
        snapshot.appendSections([0])
        snapshot.appendItems(items, toSection: 0)
        imageDataSource?.apply(snapshot)
    }
}
