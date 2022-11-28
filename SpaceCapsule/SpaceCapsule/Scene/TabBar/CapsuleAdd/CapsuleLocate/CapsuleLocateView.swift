//
//  CapsuleLocateView.swift
//  SpaceCapsule
//
//  Created by 장재훈 on 2022/11/15.
//

import MapKit
import SnapKit
import UIKit

final class CapsuleLocateView: UIView, BaseView {
    // MARK: - UI Components

    let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical

        return stackView
    }()

    let topView = UIView()

    let cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("취소", for: .normal)
        button.titleLabel?.font = .themeFont(ofSize: 24)
        button.setTitleColor(.themeBlack, for: .normal)

        return button
    }()

    let titleLabel = ThemeLabel(text: "캡슐 위치 선택", size: 24, color: .themeBlack)

    let locateMap: MKMapView = {
        let mapView = MKMapView()
        return mapView
    }()

    let cursor: UIImageView = {
        let cursor = UIImageView(image: UIImage(systemName: "plus"))
        cursor.isUserInteractionEnabled = true
        cursor.tintColor = .red
        return cursor
    }()

    let locationView = UIView()

    let locationIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .mapPin
        imageView.tintColor = .themeColor300

        return imageView
    }()

    let locationLabel = ThemeLabel(text: "화양동", size: 22, color: .themeGray400)

    let doneButton: UIButton = {
        let button = UIButton()
        button.setTitle("완료", for: .normal)
        button.titleLabel?.font = .themeFont(ofSize: FrameResource.fontSize100)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .themeColor200
        button.layer.cornerRadius = FrameResource.commonCornerRadius

        return button
    }()

    // MARK: - Lifecycle

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

    func configure() {}

    func addSubViews() {
        [cancelButton, titleLabel].forEach {
            topView.addSubview($0)
        }

        locateMap.addSubview(cursor)

        [locationIcon, locationLabel, doneButton].forEach {
            locationView.addSubview($0)
        }

        [topView, locateMap, locationView].forEach {
            mainStackView.addArrangedSubview($0)
        }

        addSubview(mainStackView)
    }

    func makeConstraints() {
        cursor.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.height.width.equalTo(20)
        }

        cancelButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(FrameResource.horizontalPadding)
            $0.top.equalToSuperview().offset(20)
            $0.bottom.equalToSuperview().offset(-20)
        }

        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(cancelButton.snp.centerY)
        }

        locationIcon.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(FrameResource.horizontalPadding)
            $0.top.equalToSuperview().offset(20)
            $0.size.equalTo(30)
        }

        locationLabel.snp.makeConstraints {
            $0.centerY.equalTo(locationIcon.snp.centerY)
            $0.leading.equalTo(locationIcon.snp.trailing).offset(20)
            $0.trailing.equalToSuperview().offset(-FrameResource.horizontalPadding)
        }

        doneButton.snp.makeConstraints {
            $0.leading.equalTo(FrameResource.horizontalPadding)
            $0.trailing.equalTo(-FrameResource.horizontalPadding)
            $0.top.equalTo(locationIcon.snp.bottom).offset(20)
            $0.bottom.equalToSuperview().offset(-FrameResource.bottomPadding)
            $0.height.equalTo(FrameResource.buttonHeight)
        }

        mainStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

#if canImport(SwiftUI) && DEBUG
    import SwiftUI
    struct CapsuleLocateViewPreview: PreviewProvider {
        static var previews: some View {
            UIViewPreview {
                CapsuleLocateView()
            }
            .previewLayout(.sizeThatFits)
        }
    }
#endif
