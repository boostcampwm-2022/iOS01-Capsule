//
//  SortPolicyHeaderView.swift
//  SpaceCapsule
//
//  Created by young june Park on 2022/11/23.
//

import UIKit

final class SortPolicyHeaderView: UITableViewHeaderFooterView {
    static let identifier: String = "SortPolicyHeaderView"
    
    let imageView = {
        let imageView = UIImageView()
        imageView.image = .sort
        imageView.tintColor = .themeGray300
        return imageView
    }()
    
    let label = {
        let label = ThemeLabel(size: 20, color: .themeGray300)
        label.text = "정렬 기준"
        return label
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        addSubviews()
        makeConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addSubviews() {
        [imageView, label].forEach {
            self.contentView.addSubview($0)
        }
    }
    
    func makeConstraints() {
        imageView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(FrameResource.horizontalPadding)
            $0.top.equalToSuperview().offset(FrameResource.verticalPadding)
        }
        label.snp.makeConstraints {
            $0.leading.equalTo(imageView.snp.trailing).offset(FrameResource.verticalPadding)
            $0.top.equalTo(imageView.snp.top)
        }
    }

  
    
}
