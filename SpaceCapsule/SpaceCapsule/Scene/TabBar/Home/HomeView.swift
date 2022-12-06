//
//  HomeView.swift
//  SpaceCapsule
//
//  Created by young june Park on 2022/11/15.
//

import SnapKit
import UIKit

final class HomeView: UIView, BaseView {
    // MARK: - UIComponents
    lazy var mainLabel: ThemeLabel = ThemeLabel(
        text: "'\(UserDefaultsManager<UserInfo>.loadData(key: .userInfo)!.nickname!)'님의 공간캡슐 '10'개",
        size: 22,
        color: .themeGray300
    )
    
    lazy var capsuleCollectionView: UICollectionView = {
        let layout = CarouselCollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(HomeCapsuleCell.self, forCellWithReuseIdentifier: HomeCapsuleCell.identifier)
        collectionView.backgroundColor = .none
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    // MARK: - LifeCycles
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
    
    // MARK: - Methods
    func configure() {
        backgroundColor = .themeBackground
    }
    func addSubViews() {
        [capsuleCollectionView, mainLabel].forEach {
            addSubview($0)
        }
    }
    func makeConstraints() {
        mainLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(self.safeAreaLayoutGuide)
        }
        capsuleCollectionView.snp.makeConstraints {
            $0.top.equalTo(mainLabel.snp.bottom)
            $0.bottom.equalTo(self.safeAreaLayoutGuide)
            $0.left.right.equalToSuperview()
        }
        
    }
}
