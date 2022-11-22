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
    
    var datasource: UICollectionViewDiffableDataSource<Int, CapsuleCellModel>!
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
    }
    
    private func fetchCapsules() {
        snapshot.deleteAllItems()
        snapshot.appendSections([0])
        // viewModel
        let capsuleCellModels: [CapsuleCellModel] = [
            CapsuleCellModel(uuid: UUID(), thumbnailImage: .logoWithText, closedDate: "123", memoryDate: "11/22/22", isOpenable: true),
            CapsuleCellModel(uuid: UUID(), thumbnailImage: .logoWithText, closedDate: "234", memoryDate: "11/22/22", isOpenable: true),
            CapsuleCellModel(uuid: UUID(), thumbnailImage: .logoWithText, closedDate: "345", memoryDate: "11/22/22", isOpenable: false),
            CapsuleCellModel(uuid: UUID(), thumbnailImage: .logoWithText, closedDate: "456", memoryDate: "11/22/22", isOpenable: true),
            CapsuleCellModel(uuid: UUID(), thumbnailImage: .logoWithText, closedDate: "567", memoryDate: "11/22/22", isOpenable: false),
            CapsuleCellModel(uuid: UUID(), thumbnailImage: .logoWithText, closedDate: "678", memoryDate: "11/22/22", isOpenable: true),
            CapsuleCellModel(uuid: UUID(), thumbnailImage: .logoWithText, closedDate: "789", memoryDate: "11/22/22", isOpenable: false),
            CapsuleCellModel(uuid: UUID(), thumbnailImage: .logoWithText, closedDate: "809", memoryDate: "11/22/22", isOpenable: false),
            CapsuleCellModel(uuid: UUID(), thumbnailImage: .logoWithText, closedDate: "90", memoryDate: "11/22/22", isOpenable: true),
            CapsuleCellModel(uuid: UUID(), thumbnailImage: .logoWithText, closedDate: "0-=", memoryDate: "11/22/22", isOpenable: true),
            CapsuleCellModel(uuid: UUID(), thumbnailImage: .logoWithText, closedDate: "asfa", memoryDate: "11/22/22", isOpenable: false)
        ]
        viewModel?.input.capsuleCellModels.onNext(capsuleCellModels)
    }
    
    func applySnapshot(capsuleCellModels: [CapsuleCellModel]) {
        snapshot.appendItems(capsuleCellModels, toSection: 0)
        datasource.apply(snapshot, animatingDifferences: true)
    }
}

extension CapsuleListViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    private func configureCollectionView() {
        datasource = UICollectionViewDiffableDataSource<Int, CapsuleCellModel>(collectionView: capsuleListView.collectionView, cellProvider: { collectionView, indexPath, capsuleCellModel in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CapsuleCell.identifier, for: indexPath) as? CapsuleCell
            cell?.configure(capsuleCellModel: capsuleCellModel)
            return cell
        })
        capsuleListView.collectionView.delegate = self
        capsuleListView.collectionView.dataSource = datasource
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewlayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: FrameResource.capsuleCellWidth, height: FrameResource.capsuleCellHeight)
    }
}
