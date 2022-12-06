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
        
        viewModel.input.capsuleCellModels
            .bind(to: homeView.capsuleCollectionView.rx.items) { [weak self] (collectionView, index, element) in
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCapsuleCell.identifier, for: IndexPath(item: index, section: 0)) as? HomeCapsuleCell else {
                    return UICollectionViewCell()
                }
                cell.configure(capsuleCellModel: element)
                return cell
            }
            .disposed(by: disposeBag)
        
        homeView.capsuleCollectionView.rx.itemHighlighted.subscribe(onNext: { [weak self] indexPath in
            if let cell = self?.homeView.capsuleCollectionView.cellForItem(at: indexPath) as? HomeCapsuleCell {
                if cell.alpha == 1.0 {
                    let pressedDownTransform = CGAffineTransform(scaleX: 0.96, y: 0.96)
                    UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 10, options: [.curveEaseInOut], animations: { cell.transform = pressedDownTransform })
                }
            }
        }).disposed(by: disposeBag)
        
        homeView.capsuleCollectionView.rx.itemUnhighlighted.subscribe(onNext: { [weak self] indexPath in
            if let cell = self?.homeView.capsuleCollectionView.cellForItem(at: indexPath) as? HomeCapsuleCell {
                if cell.alpha == 1.0 {
                    let originalTransform = CGAffineTransform(scaleX: 1, y: 1)
                    UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 10, options: [.curveEaseInOut], animations: { cell.transform = originalTransform })
                }
            }
        }).disposed(by: disposeBag)
        
        homeView.capsuleCollectionView.rx.itemSelected.subscribe(onNext: { [weak self] indexPath in
            if let cell = self?.homeView.capsuleCollectionView.cellForItem(at: indexPath) as? HomeCapsuleCell {
                if cell.alpha != 1.0 {
                    self?.homeView.capsuleCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
                }
            }
        }).disposed(by: disposeBag)
    }
}
