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

    private let scrollView = CustomScrollView()
    private let mainView = CapsuleCreateView()
    private let indicatorView = LoadingIndicatorView()

    var disposeBag = DisposeBag()
    var viewModel: CapsuleCreateViewModel?
    var imagePicker: PHPickerViewController?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .themeBackground

        setUpImagePicker()
        setUpNavigation()
        addSubViews()
        makeConstraints()

        mainView.imageCollectionView.applyDataSource()

        addTapGestureRecognizer()
        scrollView.addKeyboardNotification()

        bind()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        removeTapGestureRecognizer()
        scrollView.removeKeyboardNotification()
    }

    func bind() {
        closeButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { weakSelf, event in
                weakSelf.viewModel?.input.tapClose.onNext(event)
            })
            .disposed(by: disposeBag)

        doneButton.rx.tap
            .asObservable()
            .withUnretained(self)
            .subscribe(onNext: { weakSelf, event in
                weakSelf.viewModel?.input.tapDone.onNext(event)
            })
            .disposed(by: disposeBag)

        bindView()
        bindDescriptionTextView()
        bindViewModel()
    }

    private func bindView() {
        mainView.imageCollectionView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                if self?.mainView.imageCollectionView.cellForItem(at: indexPath) is AddImageButtonCell {
                    self?.checkAccessForPHPicker()
                }
            })
            .disposed(by: disposeBag)

        mainView.titleTextField.rx.text
            .orEmpty
            .withUnretained(self)
            .bind(onNext: { weakSelf, title in
                weakSelf.viewModel?.input.title.onNext(title)
            })
            .disposed(by: disposeBag)

        // delegate 적용 후 rx 로 변경할수 있으려나 ㅇㅅㅇ
        mainView.dateSelectView.eventHandler = { [weak self] in
            self?.view.endEditing(true)
            self?.viewModel?.input.tapDatePicker.onNext(())
        }

        mainView.locationSelectView.eventHandler = { [weak self] in
            self?.view.endEditing(true)
            self?.viewModel?.input.tapCapsuleLocate.onNext(())
        }
    }

    private func bindDescriptionTextView() {
        mainView.descriptionTextView.rx.didBeginEditing
            .subscribe(onNext: { [weak self] in
                if self?.mainView.descriptionTextView.text == self?.mainView.descriptionPlaceholder {
                    self?.mainView.descriptionTextView.text = nil
                    self?.mainView.descriptionTextView.textColor = .themeBlack
                }
            })
            .disposed(by: disposeBag)

        mainView.descriptionTextView.rx.didEndEditing
            .subscribe(onNext: { [weak self] in
                guard let text = self?.mainView.descriptionTextView.text,
                      !text.isEmpty else {
                    self?.mainView.descriptionTextView.text = self?.mainView.descriptionPlaceholder
                    self?.mainView.descriptionTextView.textColor = .themeGray200
                    return
                }
            })
            .disposed(by: disposeBag)

        mainView.descriptionTextView.rx.text
            .orEmpty
            .withUnretained(self)
            .bind(onNext: { weakSelf, description in
                weakSelf.viewModel?.input.description.onNext(description)
            })
            .disposed(by: disposeBag)
    }

    private func bindViewModel() {
        viewModel?.input.imageData
            .subscribe(onNext: { [weak self] items in
                self?.mainView.imageCollectionView.applySnapshot(items: items)
            })
            .disposed(by: disposeBag)

        viewModel?.output.address
            .withUnretained(self)
            .subscribe(onNext: { weakSelf, address in
                weakSelf.mainView.locationSelectView.setText(address.full)
            })
            .disposed(by: disposeBag)

        viewModel?.output.memoryDate
            .withUnretained(self)
            .subscribe(onNext: { weakSelf, date in
                weakSelf.mainView.dateSelectView.setText(date.dateString)
            })
            .disposed(by: disposeBag)

        viewModel?.isFieldValid
            .withUnretained(self)
            .subscribe(onNext: { weakSelf, state in
                weakSelf.navigationItem.rightBarButtonItem?.isEnabled = state
            })
            .disposed(by: disposeBag)
    }

    private func addSubViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(mainView)
    }

    private func makeConstraints() {
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        mainView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
    }

    private func setUpNavigation() {
        navigationItem.title = "캡슐 추가"
        navigationItem.leftBarButtonItem = closeButton
        navigationItem.rightBarButtonItem = doneButton
        navigationItem.rightBarButtonItem?.isEnabled = false
    }

    // PHPicker 설정
    private func setUpImagePicker() {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 10
        configuration.filter = .images

        imagePicker = PHPickerViewController(configuration: configuration)
        imagePicker?.delegate = self
    }

    private func checkAccessForPHPicker() {
        guard let imagePicker else {
            return
        }

        switch PHPhotoLibrary.authorizationStatus(for: .readWrite) {
        case .authorized, .limited:
            present(imagePicker, animated: true)

        case .notDetermined:
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { [weak self] status in
                switch status {
                case .authorized, .limited:
                    DispatchQueue.main.async {
                        self?.present(imagePicker, animated: true)
                    }
                case .notDetermined, .restricted, .denied:
                    print("앨범 접근이 필요합니다.")
                @unknown default:
                    print("\(#function) unknown error")
                }
            }

        case .denied, .restricted:
            print("앨범 접근이 필요합니다.")
        @unknown default:
            print("\(#function) unknown error")
        }
    }
}

// TODO: - rx extension 으로 뺀다음 present 부분도 coordinator 로 옮겨도 되려나~
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
                          let data = selectedImage.jpegData(compressionQuality: 0.2) else {
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
