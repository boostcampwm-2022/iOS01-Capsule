//
//  ContentImageCell.swift
//  SpaceCapsule
//
//  Created by jisu on 2022/11/29.
//

import UIKit
import SnapKit

final class DetailImageCell: UICollectionViewCell {
    struct Cell: Hashable {
        var imageURL: String
        var capsuleInfo: CapsuleInfo?
    }
    
    struct CapsuleInfo: Hashable {
        var address: String
        var date: String
    }
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
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
    
    // MARK: 이미지 위에 띄울 정보
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
        makeConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        gradientView.removeFromSuperview()
        capsuleInfoStackView.removeFromSuperview()
    }
    
    private func configure() {
        contentView.layer.cornerRadius = FrameResource.commonCornerRadius
        contentView.layer.masksToBounds = true
        
        gradient.cornerRadius = FrameResource.commonCornerRadius
        
        configureShadow()
    }
    
    private func configureShadow() {
        let rect = CGRect(x: 7, y: 7, width: bounds.width,
                          height: bounds.height)
        layer.masksToBounds = false
        layer.shadowOpacity = 0.35
        layer.shadowRadius = 3
        layer.shadowPath = UIBezierPath(roundedRect: rect, cornerRadius: FrameResource.commonCornerRadius).cgPath
    }

    private func addSubViews() {
        contentView.addSubview(imageView)
        contentView.addSubview(gradientView)
    }
    
    private func makeConstraints() {
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func addGradientLayer() {
        gradientView.layer.insertSublayer(gradient, at: 0)

        imageView.addSubview(gradientView)
        imageView.bringSubviewToFront(gradientView)
        
        gradientView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        gradient.frame = bounds
    }
    
    func addCapsuleInfo(_ capsuleInfo: CapsuleInfo) {
        addGradientLayer()
        
        capsuleDate.text = capsuleInfo.date
        capsuleLocation.text = capsuleInfo.address
        
        capsuleInfoStackView.addArrangedSubview(capsuleDate)
        capsuleInfoStackView.addArrangedSubview(capsuleLocation)
        contentView.addSubview(capsuleInfoStackView)
        
        capsuleInfoStackView.snp.makeConstraints {
            $0.left.equalToSuperview().inset(15)
            $0.bottom.equalToSuperview().inset(15)
        }
    }
}
