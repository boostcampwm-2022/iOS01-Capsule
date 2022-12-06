//
//  CapsuleDetailViewController.swift
//  SpaceCapsule
//
//  Created by young june Park on 2022/11/15.
//

import RxSwift
import SnapKit
import MapKit
import UIKit

final class CapsuleDetailViewController: UIViewController, BaseViewController {
    var disposeBag = DisposeBag()
    var viewModel: CapsuleDetailViewModel?
    private var imageDataSource: UICollectionViewDiffableDataSource<Int, DetailImageCell.Cell>?

    private let scrollView = CustomScrollView()
    private let mainView = CapsuleDetailView()

    override func viewDidLoad() {
        super.viewDidLoad()
        addSettingButton()
        applyDataSource()
        bind()
        viewModel?.input.frameWidth.onNext(view.frame.width)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scrollView.frame = CGRect(origin: .zero, size: view.frame.size)
        scrollView.backgroundColor = .themeBackground

        view.addSubview(scrollView)
        scrollView.addSubview(mainView)
        mainView.backgroundColor = .themeBackground

        makeConstrinats()
    }

    func bind() {
        viewModel?.output.imageCell
            .withUnretained(self)
            .subscribe(onNext: { owner, cells in
                owner.applySnapshot(cells: cells)
            })
            .disposed(by: disposeBag)
        
        viewModel?.output.capsuleData
            .withUnretained(self)
            .subscribe(onNext: { owner, data in
                if let capsule = data.first {
                    owner.mainView.updateCapsuleData(capsule: capsule)
                    owner.setUpNavigationTitle(capsule.title)
                }
            })
            .disposed(by: disposeBag)

        viewModel?.output.mapSnapshot
            .withUnretained(self)
            .subscribe(onNext: { owner, mapImage in
                owner.mainView.mapView.image = mapImage.first
            })
            .disposed(by: disposeBag)
        
    }
    
    private func addSettingButton() {
        mainView.settingButton.menu = getSettingsMenu()
        
        let settingButton = UIBarButtonItem(customView: mainView.settingButton)
        navigationItem.rightBarButtonItem = settingButton
    }
    
    private func getSettingsMenu() -> UIMenu {
        let deleteAction = UIAction(title: "캐슐 삭제") { [weak self] _ in
            self?.viewModel?.input.deleteCapsule.onNext(())
        }
        
        let menu = UIMenu(options: .displayInline, children: [deleteAction])
        
        return menu
    }

    private func makeConstrinats() {
        mainView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
    }
    
    func applyDataSource() {
        self.imageDataSource = UICollectionViewDiffableDataSource<Int, DetailImageCell.Cell>(collectionView: self.mainView.imageCollectionView, cellProvider: { collectionView, indexPath, item in
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailImageCell.identifier, for: indexPath) as? DetailImageCell else {
                return UICollectionViewCell()
            }
            
            cell.imageView.kr.setImage(with: item.imageURL, scale: 1.0)
            
            if let info = item.capsuleInfo {
                cell.addCapsuleInfo(info)
            }
            
            return cell
        })
    }
    
    func applySnapshot(cells: [DetailImageCell.Cell]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, DetailImageCell.Cell>()
        snapshot.appendSections([0])
        snapshot.appendItems(cells, toSection: 0)
        imageDataSource?.apply(snapshot)
    }
    
    private func setUpNavigationTitle(_ title: String) {
        navigationItem.title = title
    }
}
