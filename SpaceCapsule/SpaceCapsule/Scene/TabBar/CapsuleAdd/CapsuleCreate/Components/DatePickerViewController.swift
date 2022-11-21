//
//  DatePickerView.swift
//  SpaceCapsule
//
//  Created by 장재훈 on 2022/11/21.
//

import SnapKit
import UIKit

final class DatePickerViewController: UIViewController {
    let datePicker = UIDatePicker()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white

        configure()
        addSubViews()
        makeConstraints()
    }

    func configure() {
        datePicker.preferredDatePickerStyle = .inline
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "ko-KR")
        datePicker.timeZone = .autoupdatingCurrent
        // add target
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
}
