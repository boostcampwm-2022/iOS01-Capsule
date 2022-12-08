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

    private var emptyView: EmptyView?
    private let homeView = HomeView()

    // MARK: - Lifecycles

    override func loadView() {
        view = homeView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        viewModel?.fetchCapsuleList()

        title = "홈"
    }

    // MARK: - Rx

    func bind() {
        guard let viewModel else { return }

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

        viewModel.input.capsuleCellModels
            .bind(to: homeView.capsuleCollectionView.rx.items) { [weak self] collectionView, index, element in
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCapsuleCell.cellIdentifier, for: IndexPath(item: index, section: 0)) as? HomeCapsuleCell else {
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
