//
//  CapsuleOpenViewController.swift
//  SpaceCapsule
//
//  Created by young june Park on 2022/11/15.
//

import RxCocoa
import RxSwift
import UIKit

final class CapsuleOpenViewController: UIViewController, BaseViewController {
    var disposeBag = DisposeBag()
    var viewModel: CapsuleOpenViewModel?
    let capsuleOpenView = CapsuleOpenView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view = capsuleOpenView
        if let item = viewModel?.capsuleCellItem {
            capsuleOpenView.configure(
                item: CapsuleThumbnailView.Item(
                    thumbnailImageURL: item.thumbnailImageURL ?? "",
                    closedDateString: item.closedDate.dateTimeString,
                    memoryDateString: item.memoryDate.dateString,
                    simpleAddress: item.address
                ),
                isOpenable: item.isOpenable
            )
        }

        bind()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel?.input.viewWillAppear.onNext(())
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        capsuleOpenView.animate()
    }

    override func viewDidDisappear(_ animated: Bool) {
        viewModel?.input.viewDidDisappear.onNext(())
        super.viewDidDisappear(animated)
    }

    func bind() {
        capsuleOpenView.bottomButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                owner.handleOpenButtonTap()
            }
            .disposed(by: disposeBag)
    }

    func handleOpenButtonTap() {
        guard let capsuleCellItem = viewModel?.capsuleCellItem else {
            return
        }
        if capsuleCellItem.isOpenable {
            capsuleOpenView.shakeAnimate()
            viewModel?.input.tapOpen.onNext(())
        } else {
            capsuleOpenView.shakeAnimate()
        }
    }
}
