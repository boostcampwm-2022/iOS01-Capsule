//
//  CustomAnnotationView.swift
//  SpaceCapsule
//
//  Created by jisu on 2022/11/21.
//

import UIKit
import MapKit

final class CustomAnnotation: MKPointAnnotation {
    weak var annotationView: CustomAnnotationView?
    
    var pinImage: UIImage!
    var isOpenable: Bool = false { didSet { annotationView?.update(for: self)}}
}

final class CustomAnnotationView: MKAnnotationView {
    override var annotation: MKAnnotation? { didSet { update(for: annotation)}}
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        canShowCallout = true
        let btn = UIButton(type: .detailDisclosure)
        rightCalloutAccessoryView = btn
        update(for: annotation)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(for annotation: MKAnnotation?) {
        image = (annotation as? CustomAnnotation)?.pinImage
        backgroundColor = ((annotation as? CustomAnnotation)?.isOpenable ?? false) ? UIColor.systemRed : UIColor.systemGray
    }
}
