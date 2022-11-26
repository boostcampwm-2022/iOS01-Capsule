//
//  CapsuleCreateViewController.swift
//  SpaceCapsule
//
//  Created by young june Park on 2022/11/15.
//

import PhotosUI
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
    var imagePicker: PHPickerViewController?

    private var imageCollectionDataSource: UICollectionViewDiffableDataSource<Section, Item>!

    typealias Item = AddImageCollectionView.Cell
    private enum Section {
        case main
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .themeBackground

        setUpImagePicker()
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

        doneButton.rx.tap
            .asObservable()
            .subscribe(viewModel.input.done)
            .disposed(by: disposeBag)

        viewModel.input.imageData
            .subscribe(onNext: { [weak self] items in
                self?.applyImageCollectionSnapshot(items: items)
            })
            .disposed(by: disposeBag)

        mainView.imageCollectionView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in

                if self?.mainView.imageCollectionView.cellForItem(at: indexPath) is AddImageButtonCell,
                   let imagePicker = self?.imagePicker {
                    print("image")
                    self?.present(imagePicker, animated: true)
                }

            })
            .disposed(by: disposeBag)

        mainView.titleTextField.rx.text
            .orEmpty
            .bind(to: viewModel.input.title)
            .disposed(by: disposeBag)

        mainView.descriptionTextView.rx.text
            .orEmpty
            .bind(to: viewModel.input.description)
            .disposed(by: disposeBag)

        mainView.dateSelectView.eventHandler = { [weak self] in
            self?.viewModel?.input.tapDatePicker.onNext(())
        }
        
        mainView.locationSelectView.eventHandler = { [weak self] in
            self?.viewModel?.input.tapCapsuleLocate.onNext(())
        }
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

    // PHPicker 설정
    private func setUpImagePicker() {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 10
        configuration.filter = .images

        imagePicker = PHPickerViewController(configuration: configuration)
        imagePicker?.delegate = self
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

extension CapsuleCreateViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)

        results.forEach {
            let itemProvider = $0.itemProvider
            guard itemProvider.canLoadObject(ofClass: UIImage.self) else {
                return
            }

            itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, _ in
                DispatchQueue.global().async {
                    guard let selectedImage = image as? UIImage,
                          let data = selectedImage.pngData() else {
                        return
                    }

                    DispatchQueue.main.async {
                        self?.viewModel?.addImage(data: data)
                    }
                }
            }
        }
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
