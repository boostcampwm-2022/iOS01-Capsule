//
//  CapsuleListViewController.swift
//  SpaceCapsule
//
//  Created by young june Park on 2022/11/15.
//

import RxCocoa
import RxSwift
import UIKit

final class CapsuleListViewController: UIViewController, BaseViewController {
    var disposeBag = DisposeBag()
    var viewModel: CapsuleListViewModel?
    
    private var emptyView: EmptyView?
    private let capsuleListView = CapsuleListView()
    let refreshControl = UIRefreshControl()

    private var dataSource: UICollectionViewDiffableDataSource<Int, ListCapsuleCellItem>?
    private var snapshot = NSDiffableDataSourceSnapshot<Int, ListCapsuleCellItem>()

    override func loadView() {
        view = capsuleListView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        addSortBarButton()
        configureCollectionView()
        bind()
        bindViewModel()
    }
    
    func bind() {
        guard let viewModel else {
            return
        }
        capsuleListView.collectionView.rx.itemSelected
            .withLatestFrom(viewModel.input.capsuleCellItems, resultSelector: { indexPath, capsuleCellItems in
                viewModel.coordinator?.moveToCapsuleAccess(capsuleCellItem: capsuleCellItems[indexPath.row])
            })
            .bind(onNext: {})
            .disposed(by: disposeBag)

        capsuleListView.sortBarButtonItem.rx.tap
            .withLatestFrom(viewModel.input.sortPolicy)
            .withUnretained(self)
            .bind { owner, sortPolicy in
                owner.viewModel?.coordinator?.showSortPolicySelection(sortPolicy: sortPolicy)
            }
            .disposed(by: disposeBag)

        refreshControl.rx.controlEvent(.valueChanged)
            .withUnretained(self)
            .bind(onNext: { owner, _ in
                owner.viewModel?.refreshCapsule()
            })
            .disposed(by: disposeBag)
    }

    private func bindViewModel() {
        guard let viewModel else {
            return
        }

        viewModel.input.capsuleCellItems
            .withUnretained(self)
            .bind { owner, capsuleCellItems in
                if capsuleCellItems.isEmpty {
                    owner.view = EmptyView()
                } else {
                    owner.emptyView = nil
                    owner.view = owner.capsuleListView
                    owner.applySnapshot(capsuleCellModels: capsuleCellItems)
                    owner.viewModel?.input.refreshLoading.accept(false)
                }
            }
            .disposed(by: disposeBag)

        viewModel.input.sortPolicy
            .withUnretained(self)
            .bind { owner, sortPolicy in
                owner.applyBarButton(sortPolicy: sortPolicy)
                if let capsuleCellItems = owner.viewModel?.input.capsuleCellItems.value {
                    owner.viewModel?.sort(capsuleCellItems: capsuleCellItems, by: sortPolicy)
                }
            }
            .disposed(by: disposeBag)

        viewModel.input.refreshLoading
            .withUnretained(self)
            .bind { owner, isRefreshLoading in
                if isRefreshLoading {
                    owner.refreshControl.rx.isRefreshing.onNext(isRefreshLoading)
                } else {
                    owner.refreshControl.endRefreshing()
                }
            }
            .disposed(by: disposeBag)
    }

    private func applySnapshot(capsuleCellModels: [ListCapsuleCellItem]) {
        snapshot.deleteAllItems()
        snapshot.appendSections([0])
        snapshot.appendItems(capsuleCellModels, toSection: 0)
        dataSource?.apply(snapshot, animatingDifferences: true)
    }

    private func addSortBarButton() {
        let sortBarButton = UIBarButtonItem(customView: capsuleListView.sortBarButtonItem)
        sortBarButton.customView?.isUserInteractionEnabled = true
        navigationItem.rightBarButtonItem = sortBarButton
    }

    private func applyBarButton(sortPolicy: SortPolicy) {
        if let barItem = navigationItem.rightBarButtonItem,
           let button = barItem.customView as? UIButton {
            button.setTitle(sortPolicy.description, for: .normal)
        }
    }
}

extension CapsuleListViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    private func configureCollectionView() {
        dataSource = UICollectionViewDiffableDataSource<Int, ListCapsuleCellItem>(collectionView: capsuleListView.collectionView, cellProvider: { collectionView, indexPath, capsuleCellItem in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListCapsuleCell.cellIdentifier, for: indexPath) as? ListCapsuleCell
            cell?.configure(capsuleCellItem: capsuleCellItem)
            return cell
        })
        capsuleListView.collectionView.delegate = self
        capsuleListView.collectionView.refreshControl = refreshControl
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewlayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: FrameResource.listCapsuleCellWidth, height: FrameResource.listCapsuleCellHeight + FrameResource.bottomPadding)
    }
}
