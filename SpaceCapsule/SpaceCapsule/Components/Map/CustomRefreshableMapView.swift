//
//  CustomRefreshableMapView.swift
//  SpaceCapsule
//
//  Created by 장재훈 on 2022/11/30.
//

import MapKit
import SnapKit
import UIKit

final class CustomRefreshableMapView: CustomMapView, Refreshable {
    let refreshButton = RefreshButton()

    override init(frame: CGRect) {
        super.init(frame: frame)

        addRefreshButton()
    }
}
