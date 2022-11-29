//
//  CapsuleDetailView.swift
//  SpaceCapsule
//
//  Created by young june Park on 2022/11/15.
//

import UIKit
import MapKit

final class CapsuleDetailView: UIView, BaseView {
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = FrameResource.spacing400
        return stackView
    }()
    
    private let contentView: UIView = {
       let view = UIView()
        view.backgroundColor = .blue
        return view
    }()
    
    private let mapView: UIView = {
        let mapView = UIView()
        mapView.backgroundColor = .gray
        return mapView
    }()
    
    private let imageCollectionView: ContentImageCollectionView = {
        let customLayout = ContentImageFlowLayout()
        customLayout.scrollDirection = .horizontal
        
        let collectionView = ContentImageCollectionView(frame: .zero, collectionViewLayout: customLayout)
        collectionView.alwaysBounceHorizontal = true
        collectionView.backgroundColor = .brown
        return collectionView
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
    
    func configure() {
    }
    
    func addSubViews() {
        [imageCollectionView,
         contentView,
         mapView
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
            $0.height.equalTo(400)
        }
        
        contentView.snp.makeConstraints {
            $0.height.equalTo(500)
        }
        
        mapView.snp.makeConstraints {
            $0.height.equalTo(600)
        }
    }
}
