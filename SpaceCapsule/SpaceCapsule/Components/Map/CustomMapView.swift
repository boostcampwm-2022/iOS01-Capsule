//
//  CustomMapView.swift
//  SpaceCapsule
//
//  Created by 장재훈 on 2022/11/28.
//

import MapKit
import SnapKit
import UIKit

class CustomMapView: MKMapView {
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

        configure()
        limitMapBoundary()
        addSubViews()
        makeConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {
        mapType = .standard
        showsUserLocation = true
        setUserTrackingMode(.follow, animated: true)
    }

    private func addSubViews() {
        addSubview(currentLocationButton)
    }

    private func makeConstraints() {
        currentLocationButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(FrameResource.horizontalPadding)
            $0.bottom.equalToSuperview().offset(-FrameResource.bottomPadding)
            $0.width.height.equalTo(FrameResource.userTrackingButtonSize)
        }
    }

    private func limitMapBoundary() {
        // zoom out 제한
        cameraZoomRange = MKMapView.CameraZoomRange(
            minCenterCoordinateDistance: 100,
            maxCenterCoordinateDistance: 1500000
        )

        // 이동 제한
        let topRight = CLLocationCoordinate2DMake(39.213099, 131.134438)
        let bottomLeft = CLLocationCoordinate2DMake(32.932619, 125.355630)

        let point1 = MKMapPoint(topRight)
        let point2 = MKMapPoint(bottomLeft)

        let mapRect = MKMapRect(
            x: fmin(point1.x, point2.x),
            y: fmin(point1.y, point2.y),
            width: fabs(point1.x - point2.x),
            height: fabs(point1.y - point2.y)
        )

        setCameraBoundary(MKMapView.CameraBoundary(mapRect: mapRect), animated: true)
    }
}
