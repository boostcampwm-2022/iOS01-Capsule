//
//  CapsuleCloseViewController.swift
//  SpaceCapsule
//
//  Created by young june Park on 2022/11/15.
//

import RxCocoa
import RxSwift
import UIKit

final class CapsuleCloseViewController: UIViewController, BaseViewController {
    var disposeBag = DisposeBag()
    var viewModel: CapsuleCloseViewModel?
    let mainView = CapsuleCloseView()

    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        bind()

        if let capsule = viewModel?.output.capsule {
            mainView.configure(item:
                CapsuleCloseView.Item(
                    closedDateString: capsule.closedDate.dateTimeString,
                    memoryDateString: capsule.memoryDate.dateString,
                    address: capsule.simpleAddress,
                    thumbnailImageURL: capsule.images[0]
                )
            )
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mainView.animate()
    }

    func bind() {
        mainView.closeButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.viewModel?.input.closeButtonTapped.onNext(())
            })
            .disposed(by: disposeBag)
    }
}
