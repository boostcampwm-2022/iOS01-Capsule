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
        applyDataSource()
        bind()
        configure()
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
        mainView.settingButton.rx.tap
            .bind { [weak self] in
//                self?.
            }
            .disposed(by: disposeBag)
        
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
    
    private func configure() {
        let button = UIButton()
        button.setImage(.init(systemName: "ellipsis"), for: .normal)
        button.tintColor = .themeBlack
        
        let settingButton = UIBarButtonItem(customView: button)
        settingButton.customView?.isUserInteractionEnabled = true
        navigationItem.rightBarButtonItem = settingButton
        
//        let deleteItem = UIAction(title: "캡슐 삭제") {
//            print("캡슐 삭제 하시겠습니까?")
//        }
//
//        let
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
