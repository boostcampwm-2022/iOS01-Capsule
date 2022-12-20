//
//  CapsuleDetailViewController.swift
//  SpaceCapsule
//
//  Created by young june Park on 2022/11/15.
//

import KingReceiver
import MapKit
import RxSwift
import SnapKit
import UIKit

final class CapsuleDetailViewController: UIViewController, BaseViewController {
    var disposeBag = DisposeBag()
    var viewModel: CapsuleDetailViewModel?
    private var imageDataSource: UICollectionViewDiffableDataSource<Int, DetailImageCell.Cell>?

    private let scrollView = UIScrollView()
    let mainView = CapsuleDetailView()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .themeBackground

        addSettingButton()
        applyDataSource()
        bind()
        viewModel?.fetchCapsule()

        addSubViews()
        makeConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel?.input.viewWillAppear.onNext(())
    }

    override func viewDidDisappear(_ animated: Bool) {
        viewModel?.input.viewDidDisappear.onNext(())
        super.viewDidDisappear(animated)
    }

    func bind() {
        viewModel?.input.frameWidth.onNext(view.frame.width)

        viewModel?.output.imageCell
            .withUnretained(self)
            .subscribe(onNext: { owner, cells in
                owner.applySnapshot(cells: cells)
            })
            .disposed(by: disposeBag)

        viewModel?.output.capsuleData
            .withUnretained(self)
            .subscribe(onNext: { owner, capsule in
                owner.mainView.updateCapsuleData(capsule: capsule)
                owner.setUpNavigationTitle(capsule.title)
            })
            .disposed(by: disposeBag)

        viewModel?.output.mapSnapshot
            .withUnretained(self)
            .subscribe(onNext: { owner, mapImage in
                owner.mainView.mapView.image = mapImage
            })
            .disposed(by: disposeBag)

        mainView.settingButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.viewModel?.input.tapCapsuleSettings.accept(())
            })
            .disposed(by: disposeBag)

        mainView.imageCollectionView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                self?.viewModel?.input.tapImage.onNext(indexPath.item)
            })
            .disposed(by: disposeBag)
    }

    private func addSettingButton() {
        let settingButton = UIBarButtonItem(customView: mainView.settingButton)
        navigationItem.rightBarButtonItem = settingButton
    }

    private func makeConstraints() {
        mainView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }

        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    private func addSubViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(mainView)
    }

    func applyDataSource() {
        imageDataSource = UICollectionViewDiffableDataSource<Int, DetailImageCell.Cell>(collectionView: mainView.imageCollectionView, cellProvider: { collectionView, indexPath, item in

            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailImageCell.identifier, for: indexPath) as? DetailImageCell else {
                return UICollectionViewCell()
            }

            cell.imageView.kr.setImage(with: item.imageURL, placeholder: .empty, scale: FrameResource.openableImageScale)

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
