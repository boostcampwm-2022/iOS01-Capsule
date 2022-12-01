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
            
            self?.output.mapSnapshot.accept([snapshot.image])
        }
        
    }
}
