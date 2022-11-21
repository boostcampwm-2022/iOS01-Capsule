//
//  CapsuleCreateView.swift
//  SpaceCapsule
//
//  Created by young june Park on 2022/11/15.
//

import SnapKit
import UIKit

final class CapsuleCreateView: UIView, BaseView {
    private let mainStackView = UIStackView()
    private let inputStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical

        return stackView
    }()

    let titleLabel = ThemeLabel(text: "캡슐 이름", size: FrameResource.fontSize100, color: .themeGray300)
    let locationLabel = ThemeLabel(text: "위치", size: FrameResource.fontSize100, color: .themeGray300)
    let dateLabel = ThemeLabel(text: "추억 날짜", size: FrameResource.fontSize100, color: .themeGray300)
    let descriptionLabel = ThemeLabel(text: "내용", size: FrameResource.fontSize100, color: .themeGray300)

    let titleTextField = ThemeTextField()
    let locationSelectView = SelectButton(text: "주소를 선택하세요")
    let dateSelectView = SelectButton(text: "날짜를 선택하세요")
    let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.layer.borderColor = UIColor.themeGray300?.cgColor
        textView.layer.borderWidth = FrameResource.commonBorderWidth
        textView.layer.cornerRadius = FrameResource.commonCornerRadius
        textView.textContainerInset = UIEdgeInsets(top: 15, left: 10, bottom: 15, right: 10)
        textView.font = .themeFont(ofSize: FrameResource.fontSize100)

        return textView
    }()

    lazy var imageCollectionView = AddImageCollectionView(frame: frame)
    private let sampleImages: [UIImage?] = [.logoWithBG, .logoWithText, .logo]

    override init(frame: CGRect) {
        super.init(frame: frame)

        configure()
        addSubViews()
        makeConstraints()
        handleEvents()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure() {
        backgroundColor = .themeBackground
    }

    func addSubViews() {
        [
            imageCollectionView,
            titleLabel,
            titleTextField,
            locationLabel,
            locationSelectView,
            dateLabel,
            dateSelectView,
            descriptionLabel,
            descriptionTextView
        ].forEach {
            inputStackView.addArrangedSubview($0)
        }

        addSubview(inputStackView)
    }

    func makeConstraints() {
        imageCollectionView.snp.makeConstraints {
            $0.height.equalTo(250)
        }

        inputStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        titleTextField.snp.makeConstraints {
            $0.height.equalTo(FrameResource.textFieldHeight)
        }
        
        descriptionTextView.snp.makeConstraints {
            $0.height.equalTo(300)
        }
    }

    private func handleEvents() {
        locationSelectView.eventHandler = { print("location tapped") }
        dateSelectView.eventHandler = { print("date tapped") }
    }
}

#if canImport(SwiftUI) && DEBUG
    import SwiftUI
    struct CapsuleCreateViewPreview: PreviewProvider {
        static var previews: some View {
            UIViewPreview {
                CapsuleCreateView()
            }
            .previewLayout(.sizeThatFits)
        }
    }
#endif
