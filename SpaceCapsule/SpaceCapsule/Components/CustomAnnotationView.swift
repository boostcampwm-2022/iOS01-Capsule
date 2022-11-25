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
        centerOffset = CGPoint(x: 0, y: -frame.size.height / 2)
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
        let pinImage: UIImage?
        let resizingSize = CGSize(width: 40, height: 35)

        UIGraphicsBeginImageContext(resizingSize)
        pinImage = (annotation as? CustomAnnotation)?.pinImage
        pinImage?.draw(in: CGRect(origin: .zero, size: resizingSize))

        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        image = resizedImage
    }
}
