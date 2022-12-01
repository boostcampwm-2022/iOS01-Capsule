//
//  CapsuleDetailViewModel.swift
//  SpaceCapsule
//
//  Created by young june Park on 2022/11/15.
//

import UIKit
import RxSwift
import RxCocoa
import MapKit

final class CapsuleDetailViewModel: BaseViewModel {
    var disposeBag = DisposeBag()
    var coordinator: CapsuleDetailCoordinator?
    
    var input = Input()
    var output = Output()
    
    struct Input {
    }
    
    struct Output {
        var imageData = BehaviorRelay<[DetailImageCollectionView.Cell]>(value: [])
        var mapSnapshot = BehaviorRelay<[UIImage]>(value: [])
    }
    
    func addImage() {
        output.imageData.accept([.sampleImage1, .sampleImage2, .sampleImage3, .sampleImage4, .sampleImage5])
    }
    
    func fetchCapsuleMap(at coordinate: GeoPoint, width: CGFloat) {
        let center = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        
        let options: MKMapSnapshotter.Options = .init()
        options.region = MKCoordinateRegion(center: center, span: span)
        options.size = CGSize(width: width - (FrameResource.detailContentHInset * 2),
                              height: FrameResource.detailMapHeight)
        
        let snapshotShooter = MKMapSnapshotter(options: options)
        
        snapshotShooter.start { [weak self] snapshot, error in
            guard let snapshot = snapshot else {
                return
            }
            
            if error != nil {
                return
            }
            UIGraphicsBeginImageContextWithOptions(snapshot.image.size, true, snapshot.image.scale)
            snapshot.image.draw(at: .zero)
            
            let point = snapshot.point(for: center)
            let annotation = CustomAnnotation(coordinate: center)
            
            let annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "capsuleLocation")
            
            annotationView.contentMode = .scaleAspectFit
            annotationView.bounds = CGRect(x: 0, y: 0, width: 40, height: 40)
            
            annotationView.drawHierarchy(in: CGRect(x: point.x, y: point.y, width: annotationView.bounds.width, height: annotationView.bounds.height), afterScreenUpdates: true)
            
            let drawImage = UIGraphicsGetImageFromCurrentImageContext()
            
            if let drawImage = drawImage {
                self?.output.mapSnapshot.accept([drawImage])
            }
        }
        
    }
}
