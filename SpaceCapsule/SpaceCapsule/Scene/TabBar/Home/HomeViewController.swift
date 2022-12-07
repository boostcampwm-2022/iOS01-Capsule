//
//  HomeViewController.swift
//  SpaceCapsule
//
//  Created by young june Park on 2022/11/15.
//

import UIKit
import RxSwift
import RxCocoa

final class HomeViewController: UIViewController, BaseViewController {
    // MARK: - Properties
    private let homeView = HomeView()
    var viewModel: HomeViewModel?
    var disposeBag = DisposeBag()
    
    var centerIndex: CGFloat {
        return homeView.capsuleCollectionView.contentOffset.x / (FrameResource.homeCapsuleCellWidth * 0.75 + 10)
    }
    
    // MARK: - Lifecycles
    override func loadView() {
        view = homeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        viewModel?.fetchCapsuleList()
    }
    
    // MARK: - Rx
    func bind() {
        guard let viewModel else {
            return
        }
        
        viewModel.output.capsuleCellItems
            .bind(to: homeView.capsuleCollectionView.rx.items) { [weak self] (collectionView, index, element) in
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCapsuleCell.identifier, for: IndexPath(item: index, section: 0)) as? HomeCapsuleCell else {
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
                            UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 10, options: [.curveEaseInOut], animations: { cell.transform = pressedDownTransform })
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
                            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 10, options: [.curveEaseInOut], animations: { cell.transform = originalTransform })
                        }
                    }
                }).disposed(by: disposeBag)
        
        homeView.capsuleCollectionView.rx.itemSelected
            .withUnretained(self)
            .subscribe(
                onNext: { owner, indexPath in
                    if CGFloat(indexPath.item) == owner.centerIndex {
//                        owner.viewModel.input.tapCapsule.onNext(uuid)
                    } else {
                        owner.homeView.capsuleCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
                    }
                }).disposed(by: disposeBag)
    }
}
