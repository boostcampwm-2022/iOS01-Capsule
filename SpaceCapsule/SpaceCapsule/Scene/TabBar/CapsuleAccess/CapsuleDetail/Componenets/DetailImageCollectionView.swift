//
//  ContentImageCollectionView.swift
//  SpaceCapsule
//
//  Created by jisu on 2022/11/29.
//

import UIKit
import SnapKit

final class DetailImageCollectionView: UICollectionView {
    private var imageDataSource: UICollectionViewDiffableDataSource<Int, Cell>?
    
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
        case sampleImage1
        case sampleImage2
        case sampleImage3
        case sampleImage4
        case sampleImage5
        
        var data: Data? {
            switch self {
            case let .image(data):
                return data
            default:
                return nil
            }
        }
    }
    
    func applyDataSource() {
        imageDataSource = UICollectionViewDiffableDataSource<Int, DetailImageCollectionView.Cell>(collectionView: self, cellProvider: {collectionView, indexPath, item in
            
            switch item {
            case .image:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailImageCell.identifier, for: indexPath) as? DetailImageCell else {
                    return UICollectionViewCell()
                }
                return cell
            default:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailImageCell.identifier, for: indexPath) as? DetailImageCell else {
                    return UICollectionViewCell()
                }
                cell.imageView.image = UIImage.logoWithText
                return cell
            }
        })
    }
    
    func applySnapshot(items: [DetailImageCollectionView.Cell]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, DetailImageCollectionView.Cell>()
        snapshot.appendSections([0])
        
        // TODO: 나중에 삭제
        if let cell = DetailImageCell() as? DetailImageCollectionView.Cell {
            snapshot.appendItems(items + [cell], toSection: 0)
        } else {
            snapshot.appendItems(items, toSection: 0)
        }
        
        // snapshot.appendItems(items, toSection: 0)
        imageDataSource?.apply(snapshot)
    }
}
