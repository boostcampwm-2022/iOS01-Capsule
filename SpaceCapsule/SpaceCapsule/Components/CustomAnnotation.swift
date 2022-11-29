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
    
    var isOpenable: Bool = false {
        didSet {
            annotationView?.update(for: self)
        }
    }
    
    var pinImage: UIImage? {
        return isOpenable ? UIImage(named: "logo") : UIImage(named: "logoGray")
    }
    
    init(coordinate: CLLocationCoordinate2D) {
        super.init()
        self.coordinate = coordinate
        self.title = "\(coordinate)"
    }
}
