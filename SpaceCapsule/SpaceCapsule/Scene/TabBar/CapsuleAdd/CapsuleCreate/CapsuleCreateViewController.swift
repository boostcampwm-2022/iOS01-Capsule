//
//  CapsuleCreateViewController.swift
//  SpaceCapsule
//
//  Created by young june Park on 2022/11/15.
//

import RxCocoa
import RxSwift
import UIKit

final class CapsuleCreateViewController: UIViewController, BaseViewController {
    private let closeButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.tintColor = .themeBlack
        button.image = .close

        return button
    }()

    private let doneButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.tintColor = .themeBlack
        button.title = "완료"

        return button
    }()

    private let scrollView = UIScrollView()
    private let mainView = CapsuleCreateView()

    var disposeBag = DisposeBag()
    var viewModel: CapsuleCreateViewModel?

    private var imageCollectionDataSource: UICollectionViewDiffableDataSource<Section, Item>!

    typealias Item = AddImageCollectionView.Cell
    private enum Section {
        case main
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .themeBackground

        setUpNavigation()
        addSubViews()
        makeConstraints()
        applyImageCollectionDataSource()

        bind()
    }

    func bind() {
        guard let viewModel else { return }

        closeButton.rx.tap
            .bind(to: viewModel.input.close)
            .disposed(by: disposeBag)

        viewModel.output.imageData
            .subscribe(onNext: { [weak self] items in
                self?.applyImageCollectionSnapshot(items: items)
            })
            .disposed(by: disposeBag)
    }

    private func addSubViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(mainView)
    }

    private func makeConstraints() {
        scrollView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
        }

        mainView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()

            $0.width.equalToSuperview()
        }
    }

    private func setUpNavigation() {
        navigationItem.title = "캡슐 추가"
        navigationItem.leftBarButtonItem = closeButton
        navigationItem.rightBarButtonItem = doneButton
    }
}

extension CapsuleCreateViewController {
    private func applyImageCollectionDataSource() {
        imageCollectionDataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: mainView.imageCollectionView, cellProvider: { collectionView, indexPath, item in

            switch item {
            case .image:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddImageCell.identifier, for: indexPath) as? AddImageCell,
                      let itemData = item.data else {
                    return UICollectionViewCell()
                }

                cell.configure(item: itemData)

                return cell

            case .addButton:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddImageButtonCell.identifier, for: indexPath) as? AddImageButtonCell else {
                    return UICollectionViewCell()
                }

                return cell
            }

        })
    }

    private func applyImageCollectionSnapshot(items: [AddImageCollectionView.Cell]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.main])
        snapshot.appendItems(items, toSection: .main)
        imageCollectionDataSource?.apply(snapshot)
    }
}

// SwiftUI Preview
#if canImport(SwiftUI) && DEBUG
    import SwiftUI
    struct CapsuleCreateViewControllerPreview: PreviewProvider {
        static var previews: some View {
            CapsuleCreateViewController()
                .showPreview()
                .previewDevice(PreviewDevice(rawValue: "iPhone 14"))
        }
    }
#endif
