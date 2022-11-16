//
//  CapsuleMapView.swift
//  SpaceCapsule
//
//  Created by young june Park on 2022/11/15.
//

import UIKit
import SnapKit
import MapKit

final class CapsuleMapView: UIView, BaseView {

    var map: MKMapView = {
        let mapView = MKMapView()
        return mapView
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

    func configure() {
        backgroundColor = .themeBackground
    }

    func addSubViews() {
        [map].forEach {
            addSubview($0)
        }
    }

    func makeConstraints() {
        
        map.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
    }
}
