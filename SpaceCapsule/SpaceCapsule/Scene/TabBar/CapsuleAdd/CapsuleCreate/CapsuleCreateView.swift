//
//  CapsuleCreateView.swift
//  SpaceCapsule
//
//  Created by young june Park on 2022/11/15.
//

import RxCocoa
import RxSwift
import SnapKit
import UIKit

final class CapsuleCreateView: UIView, BaseView {
    // MARK: - UI Components

    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = FrameResource.spacing400

        return stackView
    }()

    private let inputWrapperView = UIView()
    private let inputStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical

        return stackView
    }()

    private let titleLabel = ThemeLabel(text: "캡슐 이름", size: FrameResource.fontSize110, color: .themeGray300)
    private let locationLabel = ThemeLabel(text: "위치", size: FrameResource.fontSize110, color: .themeGray300)
    private let dateLabel = ThemeLabel(text: "추억 날짜", size: FrameResource.fontSize110, color: .themeGray300)
    private let descriptionLabel = ThemeLabel(text: "내용", size: FrameResource.fontSize110, color: .themeGray300)

    let titleTextField: ThemeTextField = {
        let textField = ThemeTextField(placeholder: "추억하고 싶은 캡슐의 이름을 적어주세요 (최대 15자)")
        
        
        return textField
    }()

    let locationSelectView = SelectButton(text: "주소를 선택하세요")
    let dateSelectView = SelectButton(text: "날짜를 선택하세요")

    let descriptionPlaceholder = "추억하고 싶은 내용을 적어주세요"
    lazy var descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .themeGray100
        textView.layer.borderColor = UIColor.themeGray300?.cgColor
        textView.layer.borderWidth = FrameResource.commonBorderWidth
        textView.layer.cornerRadius = FrameResource.commonCornerRadius
        textView.font = .themeFont(ofSize: FrameResource.fontSize100)
        textView.text = descriptionPlaceholder
        textView.textColor = .themeGray200
        textView.textContainerInset = UIEdgeInsets(
            top: FrameResource.textViewVPadding,
            left: FrameResource.textViewHPadding,
            bottom: FrameResource.textViewVPadding,
            right: FrameResource.textViewHPadding
        )

        return textView
    }()

    lazy var imageCollectionView = AddImageCollectionView(frame: frame)

    // MARK: - LifeCycle

    override init(frame: CGRect) {
        super.init(frame: frame)

        configure()
        addSubViews()
        makeConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

    func configure() {
        backgroundColor = .themeBackground
    }

    func addSubViews() {
        [
            titleLabel,
            titleTextField,
            locationLabel,
            locationSelectView,
            dateLabel,
            dateSelectView,
            descriptionLabel,
            descriptionTextView,
        ].forEach {
            inputStackView.addArrangedSubview($0)
        }

        inputWrapperView.addSubview(inputStackView)

        [imageCollectionView, inputWrapperView].forEach {
            mainStackView.addArrangedSubview($0)
        }

        addSubview(mainStackView)
    }

    func makeConstraints() {
        imageCollectionView.snp.makeConstraints {
            $0.height.equalTo(FrameResource.addImageViewSize)
        }

        mainStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        inputStackView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalToSuperview().offset(FrameResource.horizontalPadding)
            $0.trailing.equalToSuperview().offset(-FrameResource.horizontalPadding)
        }

        titleTextField.snp.makeConstraints {
            $0.height.equalTo(FrameResource.textFieldHeight)
        }

        descriptionTextView.snp.makeConstraints {
            $0.height.equalTo(FrameResource.textViewHeight)
        }

        [
            titleTextField,
            locationSelectView,
            dateSelectView,
            descriptionTextView,
        ].forEach {
            inputStackView.setCustomSpacing(FrameResource.spacing200, after: $0)
        }

        [
            titleLabel,
            locationLabel,
            dateLabel,
            descriptionLabel,
        ].forEach {
            inputStackView.setCustomSpacing(FrameResource.spacing80, after: $0)
        }
    }
}
