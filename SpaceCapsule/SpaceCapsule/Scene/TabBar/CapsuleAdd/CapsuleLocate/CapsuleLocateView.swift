//
//  CapsuleLocateView.swift
//  SpaceCapsule
//
//  Created by 장재훈 on 2022/11/15.
//

import UIKit
import SnapKit
import MapKit

final class CapsuleLocateView: UIView, BaseView {
    
    var map: MKMapView = {
        let mapView = MKMapView()
        return mapView
    }()
    
    var cursor: UIImageView = {
        let cursor = UIImageView(image: UIImage(systemName: "circle"))
        cursor.isUserInteractionEnabled = true
        cursor.backgroundColor = .red
        return cursor
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
        [map, cursor].forEach {
            addSubview($0)
        }
    }
    
    func makeConstraints() {
        map.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        cursor.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.height.width.equalTo(20)
        }
    }
}
