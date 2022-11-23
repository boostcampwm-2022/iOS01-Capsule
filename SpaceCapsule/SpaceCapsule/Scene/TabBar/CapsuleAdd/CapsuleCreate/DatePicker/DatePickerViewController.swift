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

        configure()
        addSubViews()
        makeConstraints()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel?.input.viewWillDisappear.onNext(())
    }

    func configure() {
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
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.bottom.equalToSuperview()
        }
    }

    @objc private func dateChanged(_ sender: UIDatePicker) {
        viewModel?.input.dateString.onNext(sender.date.dateString)
    }
}
