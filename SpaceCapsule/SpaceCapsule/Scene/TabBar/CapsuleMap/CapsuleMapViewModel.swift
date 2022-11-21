//
//  CapsuleMapViewModel.swift
//  SpaceCapsule
//
//  Created by young june Park on 2022/11/15.
//

import Foundation
import RxCocoa
import RxSwift
import CoreLocation

final class CapsuleMapViewModel: BaseViewModel {
    var disposeBag: DisposeBag = DisposeBag()
     var coordinator: CapsuleMapCoordinator?

    var input = Input()
    var output = Output()
    
    struct Input: ViewModelInput {
        // 캡슐 마커 fetchEvent
        var annotations = PublishRelay<[CLLocationCoordinate2D]>()
        // 캡슐 마커 touchEvent
    }
    struct Output: ViewModelOutput {}

    init() {
        bind()
    }

    func bind() {}
    
    func fetchAnnotations() {
        let coordinates: [CLLocationCoordinate2D] = [
            CLLocationCoordinate2D(latitude: 37.582867, longitude: 126.027869),
            CLLocationCoordinate2D(latitude: 37.582458, longitude: 127.028570),
            CLLocationCoordinate2D(latitude: 37.583582861128654, longitude: 127.03053024855035),
        ]
        input.annotations.accept(coordinates)
    }
    
    func isOpenable(currentCoordinate: CLLocationCoordinate2D, targetCoordinate: CLLocationCoordinate2D) -> Bool {
        let currentLocation = CLLocation(latitude: currentCoordinate.latitude, longitude: currentCoordinate.longitude)
        let targetLocation = CLLocation(latitude: targetCoordinate.latitude, longitude: targetCoordinate.longitude)
        
        let distance = currentLocation.distance(from: targetLocation)
        if distance < 100.0 {
            print("openable capsule")
            return true
        }
        print("not openable capsule")
        return false
    }
}
