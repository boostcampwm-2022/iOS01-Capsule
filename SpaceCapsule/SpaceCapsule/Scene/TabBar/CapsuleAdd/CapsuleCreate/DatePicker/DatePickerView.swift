//
//  DatePickerView.swift
//  SpaceCapsule
//
//  Created by 장재훈 on 2022/12/05.
//

import RxCocoa
import RxSwift
import SnapKit
import UIKit

final class DatePickerView: UIView {
    lazy var datePicker = UIDatePicker()

    let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10

        return stackView
    }()

    private let topView = UIView()

    let cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("취소", for: .normal)
        button.titleLabel?.font = .themeFont(ofSize: FrameResource.fontSize120)
        button.setTitleColor(.themeBlack, for: .normal)

        return button
    }()

    let doneButton = ThemeButton(title: "완료")
    
    private let titleLabel = ThemeLabel(text: "추억 날짜 선택", size: FrameResource.fontSize120, color: .themeBlack)

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubViews()
        makeConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(date: Date?) {
        datePicker.date = date ?? Date()
        datePicker.maximumDate = Date()
        datePicker.preferredDatePickerStyle = .inline
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "ko-KR")
        datePicker.timeZone = .autoupdatingCurrent
        datePicker.tintColor = .themeColor300
    }

    func addSubViews() {
        [cancelButton, titleLabel].forEach {
            topView.addSubview($0)
        }

        [topView, datePicker, doneButton].forEach {
            mainStackView.addArrangedSubview($0)
        }

        addSubview(mainStackView)

    }

    func makeConstraints() {
        topView.snp.makeConstraints {
            $0.height.equalTo(FrameResource.buttonHeight)
        }
        
        cancelButton.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.top.equalToSuperview().offset(5)
            $0.bottom.equalToSuperview().offset(-5)
        }

        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(cancelButton.snp.centerY)
        }

        doneButton.snp.makeConstraints {
            $0.height.equalTo(FrameResource.buttonHeight)
        }

        mainStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(FrameResource.spacing200)
            $0.leading.equalToSuperview().offset(FrameResource.horizontalPadding)
            $0.trailing.equalToSuperview().offset(-FrameResource.horizontalPadding)
            $0.bottom.equalToSuperview().offset(-FrameResource.bottomPadding)
        }

    }
}
