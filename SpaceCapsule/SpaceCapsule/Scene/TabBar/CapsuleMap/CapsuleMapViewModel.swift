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
    // var coordinator: CapsuleMapCoordinator?

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
            CLLocationCoordinate2D(latitude: 37.6426688, longitude: 126.8319094),
            CLLocationCoordinate2D(latitude: 37.644479, longitude: 126.832957),
            CLLocationCoordinate2D(latitude: 37.644288, longitude: 126.834035),
            CLLocationCoordinate2D(latitude: 37.642940, longitude: 126.831594)
        ]
        input.annotations.accept(coordinates)
    }
}
