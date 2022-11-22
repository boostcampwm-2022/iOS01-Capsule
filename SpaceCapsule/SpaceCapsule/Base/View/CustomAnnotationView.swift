//
//  CustomAnnotationView.swift
//  SpaceCapsule
//
//  Created by jisu on 2022/11/21.
//

import UIKit
import MapKit

final class CustomAnnotation: MKPointAnnotation {
    init(coordinate: CLLocationCoordinate2D) {
        super.init()
        self.coordinate = coordinate
        self.title = "캡슐 열기"
    }
    weak var annotationView: CustomAnnotationView?
    
    var pinImage = UIImage(systemName: "circle")
    var isOpenable: Bool = false { didSet { annotationView?.update(for: self)}}
}

final class CustomAnnotationView: MKAnnotationView {
    override var annotation: MKAnnotation? { didSet { update(for: annotation)}}
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        if let custom = annotation as? CustomAnnotation {
            custom.annotationView = self
        }
        
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
        backgroundColor = ((annotation as? CustomAnnotation)?.isOpenable ?? true) ? UIColor.systemRed : UIColor.systemGray
    }
}
