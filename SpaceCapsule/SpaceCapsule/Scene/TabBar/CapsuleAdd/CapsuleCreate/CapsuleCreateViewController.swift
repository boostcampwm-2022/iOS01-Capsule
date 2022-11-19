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

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .themeBackground

        bind()
        setUpNavigation()
        addSubViews()
        makeConstraints()
    }

    func bind() {
        guard let viewModel else { return }

        closeButton.rx.tap
            .bind(to: viewModel.input.close)
            .disposed(by: disposeBag)

        viewModel.output.imageData
            .bind(
                to: mainView.imageCollectionView.rx.items(
                    cellIdentifier: AddImageCollectionViewCell.identifier,
                    cellType: AddImageCollectionViewCell.self
                )
            ) { _, item, cell in
                cell.configure(item: item)
            }
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
