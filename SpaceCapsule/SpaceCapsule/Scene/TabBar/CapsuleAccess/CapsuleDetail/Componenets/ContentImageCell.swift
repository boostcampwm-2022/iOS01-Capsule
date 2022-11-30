//
//  ContentImageCell.swift
//  SpaceCapsule
//
//  Created by jisu on 2022/11/29.
//

import UIKit
import SnapKit

final class ContentImageCell: UICollectionViewCell {
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage.logoWithBG
        return imageView
    }()
    
    private let gradientView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let gradient: CAGradientLayer = {
       let gradient = CAGradientLayer()
        gradient.colors = [UIColor.clear.cgColor, UIColor.clear.cgColor, UIColor.black.cgColor]
        gradient.locations = [0.0, 0.8, 1.0]
        return gradient
    }()
    
    private let capsuleInfoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()
    
    private let capsuleDate: UILabel = {
       let label = UILabel()
        label.textColor = .white
        label.font = .themeFont(ofSize: 20)
        return label
    }()
    
    private let capsuleLocation: UILabel = {
       let label = UILabel()
        label.textColor = .white
        label.font = .themeFont(ofSize: 30)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        configure()
        addSubViews()
        addGradientLayer()
        makeConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        contentView.layer.cornerRadius = FrameResource.commonCornerRadius
        contentView.layer.masksToBounds = true
        
        layer.masksToBounds = false
        layer.shadowOpacity = 0.5
        layer.shadowOffset = FrameResource.capsuleCellShadowOffset
        layer.shadowRadius = FrameResource.capsuleCellShadowRadius
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        
        gradient.cornerRadius = FrameResource.commonCornerRadius
        
        // TODO: 구현 후 삭제 필요
        capsuleDate.text = "2020년 6월 5일"
        capsuleLocation.text = "서울시 광진구"
    }

    private func addSubViews() {
        capsuleInfoStackView.addArrangedSubview(capsuleDate)
        capsuleInfoStackView.addArrangedSubview(capsuleLocation)
        
        contentView.addSubview(imageView)
        contentView.addSubview(gradientView)
        contentView.addSubview(capsuleInfoStackView)
    }
    
    private func makeConstraints() {
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        gradientView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        gradient.frame = bounds
        
        capsuleInfoStackView.snp.makeConstraints {
            $0.left.equalToSuperview().inset(15)
            $0.bottom.equalToSuperview().inset(15)
        }
    }
    
    private func addGradientLayer() {
        gradientView.layer.insertSublayer(gradient, at: 0)
        
        imageView.addSubview(gradientView)
        imageView.bringSubviewToFront(gradientView)
    }
}
