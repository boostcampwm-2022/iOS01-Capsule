//
//  CustomAnnotation.swift
//  SpaceCapsule
//
//  Created by jisu on 2022/11/24.
//

import UIKit
import MapKit

final class CustomAnnotation: MKPointAnnotation {
    weak var annotationView: CustomAnnotationView?
    var pinImage = UIImage(systemName: "circle")
    var isOpenable: Bool = false {
        didSet { annotationView?.update(for: self) }
    }
    
    init(coordinate: CLLocationCoordinate2D) {
        super.init()
        self.coordinate = coordinate
        self.title = "\(coordinate)"
    }
}
