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
        imageView.contentMode = .scaleAspectFit

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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .blue
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
        layer.cornerRadius = FrameResource.commonCornerRadius
        gradient.cornerRadius = FrameResource.commonCornerRadius
    }

    private func addSubViews() {
        addSubview(imageView)
        addSubview(gradientView)
    }
    
    private func makeConstraints() {
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        gradientView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        gradient.frame = bounds
    }
    
    private func addGradientLayer() {
        gradientView.layer.insertSublayer(gradient, at: 0)
        
        imageView.addSubview(gradientView)
        imageView.bringSubviewToFront(gradientView)
    }
}
