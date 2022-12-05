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
    var datePicker: UIDatePicker = UIDatePicker()
    var viewModel: DatePickerViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        addSubViews()
        makeConstraints()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel?.input.viewWillDisappear.onNext(())
        datePicker.removeTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
    }

    func configure(date: Date?) {
        datePicker.date = date ?? Date()
        datePicker.preferredDatePickerStyle = .inline
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "ko-KR")
        datePicker.timeZone = .autoupdatingCurrent
        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
    }

    func addSubViews() {
        view.addSubview(datePicker)
    }

    func makeConstraints() {
        datePicker.snp.makeConstraints {
            $0.top.equalToSuperview().offset(FrameResource.spacing200)
            $0.leading.equalToSuperview().offset(FrameResource.horizontalPadding)
            $0.trailing.equalToSuperview().offset(-FrameResource.horizontalPadding)
            $0.bottom.equalToSuperview()
        }
    }

    @objc private func dateChanged(_ sender: UIDatePicker) {
        viewModel?.input.date.onNext(sender.date)
    }
}
