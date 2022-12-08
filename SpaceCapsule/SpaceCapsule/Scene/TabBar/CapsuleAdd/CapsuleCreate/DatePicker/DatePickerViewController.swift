//
//  DatePickerView.swift
//  SpaceCapsule
//
//  Created by 장재훈 on 2022/11/21.
//

import RxSwift
import SnapKit
import UIKit

final class DatePickerViewController: UIViewController {
    var disposeBag = DisposeBag()
    var viewModel: DatePickerViewModel?

    private let mainView = DatePickerView()

    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }

    func configure(date: Date?) {
        view.backgroundColor = .white
        mainView.configure(date: date)
    }

    private func bind() {
        mainView.datePicker.rx.date
            .subscribe(onNext: { [weak self] date in
                self?.viewModel?.input.date.onNext(date)
            })
            .disposed(by: disposeBag)
        
        mainView.cancelButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.viewModel?.input.tapCancel.onNext(())
            })
            .disposed(by: disposeBag)
        
        mainView.doneButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.viewModel?.input.tapDone.onNext(())
            })
            .disposed(by: disposeBag)
    }
}
