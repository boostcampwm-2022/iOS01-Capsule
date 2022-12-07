//
//  CustomAnnotation.swift
//  SpaceCapsule
//
//  Created by jisu on 2022/11/24.
//

import MapKit
import UIKit

final class CustomAnnotation: MKPointAnnotation {
    let uuid: String?
    let date: Date?
    weak var annotationView: CustomAnnotationView?

    var isOpenable: Bool = false {
        didSet {
            annotationView?.update(for: self)
        }
    }

    var pinImage: UIImage? {
        return isOpenable ? .openableCapsule : .unopenableCapsule
    }

    required init(uuid: String?, memoryDate: Date?, latitude: Double, longitude: Double) {
        self.uuid = uuid
        date = memoryDate
        super.init()

        if let memoryDateString = memoryDate?.dateString {
            title = memoryDateString
        }
        coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
