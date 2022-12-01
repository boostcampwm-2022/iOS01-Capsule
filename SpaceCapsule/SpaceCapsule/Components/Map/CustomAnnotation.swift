//
//  CustomAnnotation.swift
//  SpaceCapsule
//
//  Created by jisu on 2022/11/24.
//

import MapKit
import UIKit

final class CustomAnnotation: MKPointAnnotation {
    let uuid: String

    weak var annotationView: CustomAnnotationView?

    var isOpenable: Bool = false {
        didSet {
            annotationView?.update(for: self)
        }
    }

    var pinImage: UIImage? {
        return isOpenable ? .openableCapsule : .unopenableCapsule
    }

    required init(uuid: String, latitude: Double, longitude: Double) {
        self.uuid = uuid

        super.init()

        coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
