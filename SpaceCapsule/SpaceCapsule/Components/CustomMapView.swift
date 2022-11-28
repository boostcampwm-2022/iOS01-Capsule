//
//  CustomMapView.swift
//  SpaceCapsule
//
//  Created by 장재훈 on 2022/11/28.
//

import MapKit
import SnapKit
import UIKit

final class CustomMapView: MKMapView {
    let image = UIImageView(image: .locationFill)

    lazy var currentLocationButton: MKUserTrackingButton = {
        let button = MKUserTrackingButton(mapView: self)
        button.backgroundColor = .white
        button.tintColor = .themeColor300
        button.layer.cornerRadius = FrameResource.userTrackingButtonSize / 2
        button.clipsToBounds = true

        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubViews()
        makeConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addSubViews() {
        image.tintColor = .red
        addSubview(currentLocationButton)
    }

    private func makeConstraints() {
        currentLocationButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-FrameResource.horizontalPadding)
            $0.bottom.equalToSuperview().offset(-FrameResource.bottomPadding)
            $0.width.height.equalTo(FrameResource.userTrackingButtonSize)
        }
    }
}
