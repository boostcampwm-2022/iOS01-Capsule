//
//  HomeViewController.swift
//  SpaceCapsule
//
//  Created by young june Park on 2022/11/15.
//

import RxCocoa
import RxSwift
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

    override func loadView() {
        view = homeView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bind()

        title = "홈"
    }

    // MARK: - Rx

    func bind() {
        guard let viewModel else {
            return
        }
        
        viewModel.input.capsuleCellModels
            .subscribe(onNext: { [weak self] in
                if $0.isEmpty {
                    self?.view = EmptyView()
                } else {
                    self?.emptyView = nil
                    self?.view = self?.homeView
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.output.featuredCapsuleCellItems
            .bind(to: homeView.capsuleCollectionView.rx.items) { collectionView, index, element in
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: HomeCapsuleCell.identifier,
                    for: IndexPath(item: index, section: 0)
                ) as? HomeCapsuleCell else {
                    return UICollectionViewCell()
                }
                cell.configure(capsuleCellModel: element)
                return cell
            }.disposed(by: disposeBag)
        
        viewModel.output.mainLabelText
            .bind(to: homeView.mainLabel.rx.text)
            .disposed(by: disposeBag)
        
        homeView.capsuleCollectionView.rx.itemHighlighted
            .withUnretained(self)
            .subscribe(
                onNext: { owner, indexPath in
                    if CGFloat(indexPath.item) == owner.centerIndex {
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
                    if CGFloat(indexPath.item) == owner.centerIndex {
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
                    if CGFloat(indexPath.item) == owner.centerIndex {
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
        
//        homeView.capsuleCollectionView.rx.modelSelected(HomeCapsuleCellItem.self)
//            .withUnretained(self)
//            .subscribe(
//                onNext: { owner, homeCapsuleCellItem in
//                    owner.viewModel?.input.tapCapsule.onNext(homeCapsuleCellItem.uuid)
//                }).disposed(by: disposeBag)
    }
}
