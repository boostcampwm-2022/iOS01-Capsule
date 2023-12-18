//
//  CustomAnnotationView.swift
//  SpaceCapsule
//
//  Created by jisu on 2022/11/21.
//

import KingReceiver
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
        guard let pinImage = (annotation as? CustomAnnotation)?.pinImage,
              let imageData = pinImage.pngData() else {
            return
        }

        let newWidth: CGFloat = FrameResource.annotationSize
        let ratio = newWidth / pinImage.size.width
        let newHeight = pinImage.size.height * ratio
        let size = CGSize(width: newWidth, height: newHeight)
        image = UIImage.resize(data: imageData, to: size, scale: FrameResource.openableImageScale)
    }
}
