//
//  ProfileView.swift
//  SpaceCapsule
//
//  Created by young june Park on 2022/11/15.
//

import UIKit

final class ProfileView: UIView, BaseView {
    let deleteButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .red
        button.setTitle("내 캡슐 전체 삭제", for: .normal)

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
    
    func configure() {}
    func addSubViews() {
        addSubview(deleteButton)
    }

    func makeConstraints() {
        deleteButton.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(300)
            $0.height.equalTo(50)
        }
    }
}
