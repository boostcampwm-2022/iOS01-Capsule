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
    private let disposeBag = DisposeBag()

    // MARK: - UI Components

    private let spacing = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 30))
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 40

        return stackView
    }()

    private let inputWrapperView = UIView()
    private let inputStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical

        return stackView
    }()

    private let titleLabel = ThemeLabel(text: "캡슐 이름", size: 22, color: .themeGray300)
    private let locationLabel = ThemeLabel(text: "위치", size: 22, color: .themeGray300)
    private let dateLabel = ThemeLabel(text: "추억 날짜", size: 22, color: .themeGray300)
    private let descriptionLabel = ThemeLabel(text: "내용", size: 22, color: .themeGray300)

    let titleTextField = ThemeTextField(placeholder: "추억하고 싶은 캡슐의 이름을 적어주세요")
    let locationSelectView = SelectButton(text: "주소를 선택하세요")
    let dateSelectView = SelectButton(text: "날짜를 선택하세요")
    
    let descriptionPlaceholder = "추억하고 싶은 내용을 적어주세요"
    lazy var descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .themeGray100
        textView.layer.borderColor = UIColor.themeGray300?.cgColor
        textView.layer.borderWidth = FrameResource.commonBorderWidth
        textView.layer.cornerRadius = FrameResource.commonCornerRadius
        textView.textContainerInset = UIEdgeInsets(top: 15, left: 10, bottom: 15, right: 10)
        textView.font = .themeFont(ofSize: FrameResource.fontSize100)
        textView.text = descriptionPlaceholder
        textView.textColor = .themeGray200

        return textView
    }()

    lazy var imageCollectionView = AddImageCollectionView(frame: frame)
    private let sampleImages: [UIImage?] = [.logoWithBG, .logoWithText, .logo]

    // MARK: - LifeCycle

    override init(frame: CGRect) {
        super.init(frame: frame)

        bind()
        configure()
        addSubViews()
        makeConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

    private func bind() {
        descriptionTextView.rx.didBeginEditing
            .subscribe(onNext: { [weak self] in
                if self?.descriptionTextView.text == self?.descriptionPlaceholder {
                    self?.descriptionTextView.text = nil
                    self?.descriptionTextView.textColor = .themeBlack
                }
            })
            .disposed(by: disposeBag)
        
        descriptionTextView.rx.didEndEditing
            .subscribe(onNext: { [weak self] in
                guard let text = self?.descriptionTextView.text,
                   !text.isEmpty else {
                    self?.descriptionTextView.text = self?.descriptionPlaceholder
                    self?.descriptionTextView.textColor = .themeGray200
                    return
                }
            })
            .disposed(by: disposeBag)
    }

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
            spacing,
        ].forEach {
            inputStackView.addArrangedSubview($0)
        }

        inputWrapperView.addSubview(inputStackView)

        [spacing, imageCollectionView, inputWrapperView].forEach {
            mainStackView.addArrangedSubview($0)
        }

        addSubview(mainStackView)
    }

    func makeConstraints() {
        imageCollectionView.snp.makeConstraints {
            $0.height.equalTo(250)
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
            $0.height.equalTo(200)
        }

        [
            titleTextField,
            locationSelectView,
            dateSelectView,
            descriptionTextView,
        ].forEach {
            inputStackView.setCustomSpacing(20, after: $0)
        }

        [
            titleLabel,
            locationLabel,
            dateLabel,
            descriptionLabel,
        ].forEach {
            inputStackView.setCustomSpacing(8, after: $0)
        }
    }
}
