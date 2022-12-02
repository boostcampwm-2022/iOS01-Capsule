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
    let capsuleListView = CapsuleListView()
    let refreshControl = UIRefreshControl()

    private var dataSource: UICollectionViewDiffableDataSource<Int, ListCapsuleCellModel>?
    private var snapshot = NSDiffableDataSourceSnapshot<Int, ListCapsuleCellModel>()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let parent = viewModel?.coordinator?.parent as? TabBarCoordinator {
            parent.tabBarWillHide(false)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view = capsuleListView
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
            .withLatestFrom(viewModel.input.capsuleCellModels, resultSelector: { indexPath, capsuleCellModels in
                viewModel.coordinator?.showCapsuleOpen(capsuleCellModel: capsuleCellModels[indexPath.row])
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
        viewModel.input.capsuleCellModels
            .withUnretained(self)
            .bind { owner, capsuleCellModels in
                owner.applySnapshot(capsuleCellModels: capsuleCellModels)
                owner.viewModel?.input.refreshLoading.accept(false)
            }
            .disposed(by: disposeBag)

        viewModel.input.sortPolicy
            .withUnretained(self)
            .bind { owner, sortPolicy in
                owner.applyBarButton(sortPolicy: sortPolicy)
                if let capsuleCellModels = owner.viewModel?.input.capsuleCellModels.value {
                    owner.viewModel?.sort(capsuleCellModels: capsuleCellModels, by: sortPolicy)
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

    private func applySnapshot(capsuleCellModels: [ListCapsuleCellModel]) {
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
        dataSource = UICollectionViewDiffableDataSource<Int, ListCapsuleCellModel>(collectionView: capsuleListView.collectionView, cellProvider: { collectionView, indexPath, capsuleCellModel in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListCapsuleCell.cellIdentifier, for: indexPath) as? ListCapsuleCell
            cell?.configure(capsuleCellModel: capsuleCellModel)
            return cell
        })
        capsuleListView.collectionView.delegate = self
        capsuleListView.collectionView.refreshControl = refreshControl
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewlayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: FrameResource.listCapsuleCellWidth, height: FrameResource.listCapsuleCellHeight + FrameResource.bottomPadding)
    }
}
