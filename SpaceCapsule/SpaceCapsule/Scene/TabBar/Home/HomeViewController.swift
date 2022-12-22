//
//  HomeViewController.swift
//  SpaceCapsule
//
//  Created by young june Park on 2022/11/15.
//

import RxCocoa
import RxSwift
import SnapKit
import UIKit

final class HomeViewController: UIViewController, BaseViewController {
    // MARK: - Properties

    var viewModel: HomeViewModel?
    var disposeBag = DisposeBag()
        
    var centerIndex: CGFloat {
        return homeView.capsuleCollectionView.contentOffset.x / (FrameResource.homeCapsuleCellWidth * 0.75 + 10)
    }
    
    private var emptyView: EmptyView?
    private let homeView = HomeView()

    // MARK: - Lifecycles

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "홈"
        
        homeView.capsuleCollectionView.dataSource = self
        
        configureView()
        bind()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel?.input.viewWillAppear.onNext(())
    }
    
    // MARK: - Functions
    
    private func configureView() {
        view.backgroundColor = .themeBackground
        
        viewModel?.output.featuredCapsuleCellItems
            .withUnretained(self)
            .bind { owner, capsuleCellItems in
                owner.view.subviews.forEach({ $0.removeFromSuperview() })
                if capsuleCellItems.isEmpty {
                    owner.showEmptyView()
                } else {
                    owner.emptyView = nil
                    owner.showHomeView()
                    owner.homeView.capsuleCollectionView.reloadDataWithCompletion {
                        guard let featuredCapsules = owner.viewModel?.output.featuredCapsules else {
                            return
                        }
                        let startIndex = 100_000_000
                        let randomInt = Int.random(in: startIndex..<(startIndex + featuredCapsules.count))
                        owner.homeView.capsuleCollectionView.scrollToItem(
                            at: IndexPath(item: randomInt, section: 0),
                            at: .centeredHorizontally,
                            animated: false
                        )
                    }
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func showEmptyView() {
        emptyView = EmptyView()
        guard let emptyView = emptyView else {
            return
        }
        view.addSubview(emptyView)
        
        emptyView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func showHomeView() {
        view.addSubview(homeView)
        
        homeView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func getIndexRange(index: Int) -> ClosedRange<CGFloat> {
        let index = CGFloat(index)
        return (index - 0.1)...(index + 0.1)
    }
    
    // MARK: - Rx

    func bind() {
        guard let viewModel else {
            return
        }
        
        viewModel.output.userCapsuleStatus
            .subscribe(onNext: { [weak self] status in
                self?.homeView.mainStatusLabel.updateUserCapsuleStatus(
                    nickname: status.nickname,
                    capsuleCounts: String(status.capsuleCounts)
                )
            })
            .disposed(by: disposeBag)
        
        homeView.capsuleCollectionView.rx.itemHighlighted
            .withUnretained(self)
            .subscribe(
                onNext: { owner, indexPath in
                    if owner.getIndexRange(index: indexPath.item) ~= owner.centerIndex {
                        if let cell = owner.homeView.capsuleCollectionView.cellForItem(at: indexPath) as? HomeCapsuleCell {
                            let pressedDownTransform = CGAffineTransform(scaleX: 0.96, y: 0.96)
                            UIView.animate(
                                withDuration: 0.2,
                                delay: 0,
                                usingSpringWithDamping: 0.4,
                                initialSpringVelocity: 10,
                                options: [.curveEaseInOut],
                                animations: { cell.transform = pressedDownTransform }
                            )
                        }
                    }
                }).disposed(by: disposeBag)
        
        homeView.capsuleCollectionView.rx.itemUnhighlighted
            .withUnretained(self)
            .subscribe(
                onNext: { owner, indexPath in
                    if owner.getIndexRange(index: indexPath.item) ~= owner.centerIndex {
                        if let cell = owner.homeView.capsuleCollectionView.cellForItem(at: indexPath) as? HomeCapsuleCell {
                            let originalTransform = CGAffineTransform(scaleX: 1, y: 1)
                            UIView.animate(
                                withDuration: 0.4,
                                delay: 0,
                                usingSpringWithDamping: 0.4,
                                initialSpringVelocity: 10,
                                options: [.curveEaseInOut],
                                animations: { cell.transform = originalTransform }
                            )
                        }
                    }
                }).disposed(by: disposeBag)
        
        homeView.capsuleCollectionView.rx.itemSelected
            .withUnretained(self)
            .subscribe(
                onNext: { owner, indexPath in
                    if owner.getIndexRange(index: indexPath.item) ~= owner.centerIndex {
                        if let cell = owner.homeView.capsuleCollectionView.cellForItem(at: indexPath) as? HomeCapsuleCell {
                            guard let uuid = cell.uuid else {
                                return
                            }
                            owner.viewModel?.input.tapCapsule.onNext(uuid)
                        }
                    } else {
                        owner.homeView.capsuleCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
                    }
                }).disposed(by: disposeBag)
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let featuredCapsules = viewModel?.output.featuredCapsules else {
            return 0
        }
        return featuredCapsules.isEmpty ? 0 : Int.max
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: HomeCapsuleCell.identifier,
            for: indexPath
        ) as? HomeCapsuleCell else {
            return UICollectionViewCell()
        }
        guard let featuredCapsules = viewModel?.output.featuredCapsules else {
            return cell
        }
        cell.configure(capsuleCellModel: featuredCapsules[indexPath.item % featuredCapsules.count])
        return cell
    }
}
