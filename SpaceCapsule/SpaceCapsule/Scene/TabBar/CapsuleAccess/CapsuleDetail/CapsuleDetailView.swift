//
//  CapsuleDetailView.swift
//  SpaceCapsule
//
//  Created by young june Park on 2022/11/15.
//

import UIKit
import MapKit

final class CapsuleDetailView: UIView, BaseView {
    let settingButton: UIButton = {
        let button = UIButton()
        button.setImage(.init(systemName: "ellipsis"), for: .normal)
        button.tintColor = .themeBlack
        
        return button
    }()

    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = FrameResource.spacing400
        stackView.alignment = .center
        
        return stackView
    }()
    
    lazy var imageCollectionView = {
        let customLayout = createLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: customLayout)
        collectionView.register(DetailImageCell.self, forCellWithReuseIdentifier: DetailImageCell.identifier)
        collectionView.alwaysBounceHorizontal = true
        collectionView.backgroundColor = .clear
        collectionView.alwaysBounceHorizontal = false
        collectionView.showsHorizontalScrollIndicator = false
        
        return collectionView
    }()
    
    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = FrameResource.spacing200
        
        return stackView
    }()
    
    private let closedDateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .themeGray300
        label.font = .themeFont(ofSize: 16)
        
        return label
    }()
    
    private let descriptionView: UITextView = {
        let view = UITextView()
        view.isUserInteractionEnabled = false
        view.textColor = .themeGray400
        view.font = .themeFont(ofSize: 24)
        view.isScrollEnabled = false
        view.backgroundColor = .clear
        
        return view
    }()
    
    let mapView: UIImageView = {
        let mapView = UIImageView()
        mapView.contentMode = .scaleAspectFit
        mapView.layer.borderWidth = 0.5
        mapView.layer.borderColor = UIColor.themeGray300?.cgColor
        
        return mapView
    }()
    
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
    
    func configure() {}
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func addSubViews() {
        [closedDateLabel,
         descriptionView,
         mapView].forEach {
            contentStackView.addArrangedSubview($0)
        }
        
        [imageCollectionView,
         contentStackView
        ].forEach {
            mainStackView.addArrangedSubview($0)
        }
        
        self.addSubview(mainStackView)
    }
    
    func makeConstraints() {
        mainStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        imageCollectionView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(FrameResource.detailImageCollectionViewHeight)
        }
        
        contentStackView.snp.makeConstraints {
            $0.width.equalToSuperview().inset(FrameResource.detailContentHInset)
        }
        
        mapView.snp.makeConstraints {
            $0.height.equalTo(FrameResource.detailMapHeight)
        }
    }
    
    func updateCapsuleData(capsule: Capsule) {
        closedDateLabel.text = "밀봉시간: \(capsule.closedDate.dateString)"
        descriptionView.text = capsule.description
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalHeight(1))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(FrameResource.detailImageViewWidth), heightDimension: .absolute(FrameResource.detailImageViewHeight))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        section.interGroupSpacing = FrameResource.spacing200
        
        return UICollectionViewCompositionalLayout(section: section)
    }
}
