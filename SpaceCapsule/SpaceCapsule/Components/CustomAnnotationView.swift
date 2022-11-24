//
//  CustomAnnotationView.swift
//  SpaceCapsule
//
//  Created by jisu on 2022/11/21.
//

import UIKit
import MapKit

final class CustomAnnotationView: MKAnnotationView {
    override var annotation: MKAnnotation? {
        didSet {
            (annotation as? CustomAnnotation)?.annotationView = self
        }
    }
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        configure()
        update(for: annotation)
    }
    
    private func configure() {
        canShowCallout = true
        
        let detailButton = UIButton(type: .detailDisclosure)
        rightCalloutAccessoryView = detailButton
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
