//
//  CapsuleListViewController.swift
//  SpaceCapsule
//
//  Created by young june Park on 2022/11/15.
//

import UIKit
import RxSwift
import RxCocoa

final class CapsuleListViewController: UIViewController, BaseViewController {
    var disposeBag = DisposeBag()
    var viewModel: CapsuleListViewModel?
    let capsuleListView = CapsuleListView()
    
    private var dataSource: UICollectionViewDiffableDataSource<Int, CapsuleCellModel>?
    private var snapshot = NSDiffableDataSourceSnapshot<Int, CapsuleCellModel>()
    
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
        viewModel?.fetchCapsules()
        viewModel?.input.sortPolicy.onNext(.nearest)
    }
    
    func bind() {
        guard let viewModel else {
            return
        }
        viewModel.input.capsuleCellModels
            .withUnretained(self)
            .bind { weakSelf, capsuleCellModels in
                weakSelf.applySnapshot(capsuleCellModels: capsuleCellModels)
            }
            .disposed(by: disposeBag)
        
        viewModel.input.sortPolicy
            .withLatestFrom(viewModel.input.capsuleCellModels, resultSelector: { sortPolicy, capsuleCellModels in
                self.viewModel?.sort(capsuleCellModels: capsuleCellModels, by: sortPolicy)
            })
            .bind(onNext: {})
            .disposed(by: disposeBag)
        
        capsuleListView.collectionView.rx.itemSelected
            .withUnretained(self)
            .bind { _, indexPath in
                // TODO: 캡슐 오픈 화면 연동
            }
            .disposed(by: disposeBag)
        
        capsuleListView.sortBarButtonItem.rx.tap
            .withLatestFrom(viewModel.input.sortPolicy)
            .withUnretained(self)
            .bind { weakSelf, sortPolicy in
                weakSelf.viewModel?.coordinator?.showSortPolicySelection(sortPolicy: sortPolicy)
            }
            .disposed(by: disposeBag)
        
    }
    
    private func applySnapshot(capsuleCellModels: [CapsuleCellModel]) {
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
}

extension CapsuleListViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    private func configureCollectionView() {
        dataSource = UICollectionViewDiffableDataSource<Int, CapsuleCellModel>(collectionView: capsuleListView.collectionView, cellProvider: { collectionView, indexPath, capsuleCellModel in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CapsuleCell.identifier, for: indexPath) as? CapsuleCell
            cell?.configure(capsuleCellModel: capsuleCellModel)
            return cell
        })
        capsuleListView.collectionView.delegate = self
        capsuleListView.collectionView.dataSource = dataSource
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewlayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: FrameResource.capsuleCellWidth, height: FrameResource.capsuleCellHeight + FrameResource.bottomPadding)
    }
    
}
