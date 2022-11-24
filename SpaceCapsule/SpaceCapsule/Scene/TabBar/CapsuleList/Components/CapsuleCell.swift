//
//  CapsuleCell.swift
//  SpaceCapsule
//
//  Created by young june Park on 2022/11/22.
//

import UIKit
import SnapKit
import CoreLocation

struct CapsuleCellModel: Hashable, Equatable {
    let uuid: UUID
    let thumbnailImage: UIImage?
    let address: String
    let closedDate: String
    let memoryDate: String
    let isOpenable: Bool
    let coordinate: CLLocationCoordinate2D
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.uuid == rhs.uuid
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
    
    func dateToInt() -> Int {
        let arr = memoryDate.split(separator: " ")
        let year = arr[0].replacingOccurrences(of: "년", with: "")
        var month = arr[1].replacingOccurrences(of: "월", with: "")
        var day = arr[2].replacingOccurrences(of: "일", with: "")
        if month.count == 1 {
            month = "0" + month
        }
        if day.count == 1 {
            day = "0" + day
        }
        guard let result = Int(year + month + day) else {
            return 0
        }
        return result
    }
    
    func distance(from: CLLocationCoordinate2D) -> Double {
        let latitudeDistance = abs(from.latitude - coordinate.latitude)
        let longitudeDistance = abs(from.longitude - coordinate.longitude)
        
        return sqrt(pow(latitudeDistance, 2) + pow(longitudeDistance, 2))
    }
}

final class CapsuleCell: UICollectionViewCell {
    static let identifier = "CapsuleCell"
    
    var thumbnailImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = FrameResource.capsuleCellWidth / 2
        imageView.clipsToBounds = true
        imageView.image = UIImage.logoWithBG
        return imageView
    }()
    
    var thumbnailImageContainerView = {
        let view = UIView()
        view.layer.shadowOffset = CGSize(width: 4, height: 4)
        view.layer.shadowRadius = 4
        view.layer.shadowOpacity = 0.5
        view.layer.cornerRadius = FrameResource.capsuleCellWidth / 2
        return view
    }()
    
    var descriptionLabel = {
        let label = ThemeLabel(text: "xxxx년 x월 x일\nxx시 xx구에서", size: 16, color: .themeBlack)
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        makeConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addSubviews() {
        thumbnailImageContainerView.addSubview(thumbnailImageView)
        [thumbnailImageContainerView, descriptionLabel].forEach {
            self.contentView.addSubview($0)
        }
    }
    
    func makeConstraints() {
        thumbnailImageContainerView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().multipliedBy(0.8)
            $0.width.equalTo(FrameResource.capsuleCellWidth)
            $0.height.equalTo(FrameResource.capsuleCellHeight)
        }
        
        thumbnailImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(thumbnailImageContainerView.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
        }
    }

    func configure(capsuleCellModel: CapsuleCellModel) {
        thumbnailImageView.image = capsuleCellModel.thumbnailImage
        descriptionLabel.text = "\(capsuleCellModel.memoryDate)\n\(capsuleCellModel.address)에서"
        thumbnailImageView.subviews.forEach {
            $0.removeFromSuperview()
        }
        if capsuleCellModel.isOpenable == false {
            applyUnOpenableEffect(closeDate: capsuleCellModel.closedDate)
        }
    }
    
    func applyUnOpenableEffect(closeDate: String) {
        applyBlurEffect()
        applyLockImage()
        applyCapsuleDate(closeDate: closeDate)
    }
    
    private func applyBlurEffect() {
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.layer.cornerRadius = FrameResource.capsuleCellWidth / 2
        blurEffectView.clipsToBounds = true
        thumbnailImageView.addSubview(blurEffectView)
        
        blurEffectView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalToSuperview()
        }
    }
    
    private func applyLockImage() {
        let lockImageView = UIImageView()
        lockImageView.image = UIImage(systemName: "lock.fill")
        lockImageView.tintColor = .themeGray300
        thumbnailImageView.addSubview(lockImageView)
        
        lockImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(50)
        }
    }
    
    private func applyCapsuleDate(closeDate: String) {
        let dateLabel = ThemeLabel(text: "밀봉시간:\(closeDate)", size: 13, color: .themeGray300)
        dateLabel.textAlignment = .center
        thumbnailImageView.addSubview(dateLabel)
        
        dateLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().multipliedBy(1.4)
        }
    }
}
