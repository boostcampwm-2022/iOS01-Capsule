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
        stackView.spacing = 0
        stackView.alignment = .center
        return stackView
    }()
    
    let imageCollectionView = DetailImageCollectionView(frame: .zero)
    
    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = FrameResource.spacing400
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
        view.textColor = .themeGray300
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
        closedDateLabel.text = capsule.closedDate.dateString
        descriptionView.text = capsule.description
    }
}
