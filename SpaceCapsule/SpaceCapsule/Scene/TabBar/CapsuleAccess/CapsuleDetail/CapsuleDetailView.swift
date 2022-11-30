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
        stackView.spacing = FrameResource.spacing50
        return stackView
    }()
    
    private let closingDateView: UILabel = {
        let label = UILabel()
        label.textColor = .themeGray300
        label.font = .themeFont(ofSize: 16)
        return label
    }()
    
    private let contentView: UITextView = {
       let view = UITextView()
        view.isUserInteractionEnabled = false
        view.textColor = .themeGray300
        view.font = .themeFont(ofSize: 24)
        view.backgroundColor = .blue
        view.isScrollEnabled = false
        return view
    }()
    
    private let mapView: UIView = {
        let mapView = UIView()
        mapView.backgroundColor = .gray
        return mapView
    }()
    
    private let imageCollectionView: ContentImageCollectionView = {        
        let collectionView = ContentImageCollectionView(frame: .zero)
        collectionView.alwaysBounceHorizontal = true
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self

        configure()
        addSubViews()
        makeConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        // TODO: 구현 후 삭제필요
        closingDateView.text = "밀봉시간: 2010년 7월 1일"
        contentView.text = "날씨가 너무 좋았던 날\n 영준이를 오랜만에 봐서 좋았다\n 지수랑 민중이랑 영준이랑 김치 떡볶이 먹고 인생네컷도 찍었다.\n 지수는 소주를 3병이나 먹는게 진짜 신기하다"
    }
    
    func addSubViews() {
        [imageCollectionView,
         closingDateView,
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
            $0.height.equalTo(FrameResource.detailImageCollectionViewHeight)
        }
        
        mapView.snp.makeConstraints {
            $0.height.equalTo(600)
        }
    }
}

extension CapsuleDetailView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: ContentImageCell.identifier, for: indexPath)
    }
}
