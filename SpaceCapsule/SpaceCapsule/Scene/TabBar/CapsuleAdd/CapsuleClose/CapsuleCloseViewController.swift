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
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mainView.animate()
    }

    func bind() {
        mainView.closeButton.rx.tap
            .withUnretained(self)
            .bind(onNext: { owner, _ in
                owner.viewModel?.input.tapClose.onNext(())
            })
            .disposed(by: disposeBag)

        viewModel?.output.capsule
            .compactMap { $0 }
            .withUnretained(self)
            .subscribe(onNext: { owner, capsule in
                owner.mainView.configure(item:
                    CapsuleCloseView.Item(
                        closedDateString: capsule.closedDate.dateTimeString,
                        memoryDateString: capsule.memoryDate.dateString,
                        simpleAddress: capsule.simpleAddress,
                        thumbnailImageURL: capsule.images[safe: 0] ?? ""
                    )
                )
            })
            .disposed(by: disposeBag)
    }
}
