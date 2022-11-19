//
//  AddImageCollectionViewFooter.swift
//  SpaceCapsule
//
//  Created by 장재훈 on 2022/11/19.
//

import SnapKit
import UIKit

class AddImageCollectionViewFooter: UICollectionReusableView {
    let addImageButton: UIButton = {
        let button = UIButton()
        button.setImage(.addImage, for: .normal)

        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubViews()
        makeConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubViews() {
        addSubview(addImageButton)
    }
    
    private func makeConstraints() {
        addImageButton.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
        }
    }
}
