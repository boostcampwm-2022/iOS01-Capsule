//
//  CustomAnnotationView.swift
//  SpaceCapsule
//
//  Created by jisu on 2022/11/21.
//

import MapKit
import UIKit

final class CustomAnnotationView: MKAnnotationView {
    private let detailButton = {
        let detailButton = UIButton(type: .detailDisclosure)
        detailButton.setImage(UIImage.mapPin, for: .normal)
        detailButton.tintColor = .red
        return detailButton
    }()

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

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {
        centerOffset = CGPoint(x: 0, y: -frame.size.height / 2)
        canShowCallout = true
        rightCalloutAccessoryView = detailButton
    }

    func update(for annotation: MKAnnotation?) {
        image = (annotation as? CustomAnnotation)?.pinImage?.resize(40)
    }
}
