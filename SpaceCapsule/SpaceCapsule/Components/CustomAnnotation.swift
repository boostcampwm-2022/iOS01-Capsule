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
        return isOpenable ? UIImage(named: "logo") : UIImage(named: "logoGray")
    }

//    required init(uuid: String, coordinate: CLLocationCoordinate2D) {
//        self.uuid = uuid
//
//        super.init()
//
//        self.coordinate = coordinate
//    }

    required init(uuid: String, latitude: Double, longitude: Double) {
        self.uuid = uuid

        super.init()

        coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
