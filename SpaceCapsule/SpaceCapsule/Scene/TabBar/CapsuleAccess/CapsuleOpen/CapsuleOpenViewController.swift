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

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .themeBackground
        bind()
    }

    override func viewWillDisappear(_ animated: Bool) {
        viewModel?.input.popViewController.onNext(())
        super.viewWillDisappear(animated)
    }

    func bind() { }
}
