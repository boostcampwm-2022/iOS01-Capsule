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
    
    var dataSource: UICollectionViewDiffableDataSource<Int, CapsuleCellModel>!
    var snapshot = NSDiffableDataSourceSnapshot<Int, CapsuleCellModel>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = capsuleListView
        configureCollectionView()
        bind()
        fetchCapsules()
    }
    
    func bind() {
        guard let viewModel else {return}
        viewModel.input.capsuleCellModels.bind { capsuleCellModels in
            self.applySnapshot(capsuleCellModels: capsuleCellModels)
        }.disposed(by: disposeBag)
        
        capsuleListView.collectionView.rx.itemSelected.bind { indexPath in
           print(indexPath)
        }.disposed(by: disposeBag)
    }
    
    private func fetchCapsules() {
        // viewModel
        let capsuleCellModels: [CapsuleCellModel] = [
            CapsuleCellModel(uuid: UUID(), thumbnailImage: .logoWithText, address: "서울시 광진구", closedDate: "123", memoryDate: "1", isOpenable: true),
            CapsuleCellModel(uuid: UUID(), thumbnailImage: .logoWithText, address: "서울시 광진구", closedDate: "234", memoryDate: "2", isOpenable: true),
            CapsuleCellModel(uuid: UUID(), thumbnailImage: .logoWithText, address: "서울시 광진구", closedDate: "345", memoryDate: "3", isOpenable: false),
            CapsuleCellModel(uuid: UUID(), thumbnailImage: .logoWithText, address: "서울시 광진구", closedDate: "456", memoryDate: "4", isOpenable: true),
            CapsuleCellModel(uuid: UUID(), thumbnailImage: .logoWithText, address: "서울시 광진구", closedDate: "567", memoryDate: "5", isOpenable: false),
            CapsuleCellModel(uuid: UUID(), thumbnailImage: .logoWithText, address: "서울시 광진구", closedDate: "678", memoryDate: "6", isOpenable: true),
            CapsuleCellModel(uuid: UUID(), thumbnailImage: .logoWithText, address: "서울시 광진구", closedDate: "789", memoryDate: "7", isOpenable: false),
            CapsuleCellModel(uuid: UUID(), thumbnailImage: .logoWithText, address: "서울시 광진구", closedDate: "809", memoryDate: "8", isOpenable: false),
            CapsuleCellModel(uuid: UUID(), thumbnailImage: .logoWithText, address: "서울시 광진구", closedDate: "90", memoryDate: "9", isOpenable: true),
            CapsuleCellModel(uuid: UUID(), thumbnailImage: .logoWithText, address: "서울시 광진구", closedDate: "0-=", memoryDate: "10", isOpenable: true),
            CapsuleCellModel(uuid: UUID(), thumbnailImage: .logoWithText, address: "서울시 광진구", closedDate: "asfa", memoryDate: "11", isOpenable: false)
        ]
        viewModel?.input.capsuleCellModels.onNext(capsuleCellModels)
    }
    
    func applySnapshot(capsuleCellModels: [CapsuleCellModel]) {
        snapshot.deleteAllItems()
        snapshot.appendSections([0])
        snapshot.appendItems(capsuleCellModels, toSection: 0)
        dataSource.apply(snapshot, animatingDifferences: true)
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
