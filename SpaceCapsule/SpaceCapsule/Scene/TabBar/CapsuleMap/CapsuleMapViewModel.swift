//
//  CapsuleMapViewModel.swift
//  SpaceCapsule
//
//  Created by young june Park on 2022/11/15.
//

import CoreLocation
import Foundation
import RxCocoa
import RxSwift

final class CapsuleMapViewModel: BaseViewModel {
    var disposeBag: DisposeBag = DisposeBag()
    var coordinator: CapsuleMapCoordinator?

    var input = Input()
    var output = Output()

    struct Input: ViewModelInput {
//        var annotations = PublishRelay<[CLLocationCoordinate2D]>()

        // 캡슐 마커 touchEvent
    }

    struct Output: ViewModelOutput {
        let annotations = BehaviorRelay<[CustomAnnotation]>(value: [])
    }

    init() {
        bind()
    }

    func bind() {
        AppDataManager.shared.capsules
            .withUnretained(self)
            .subscribe(onNext: { owner, capsules in

                let annotations = capsules.map {
                    return CustomAnnotation(
                        uuid: $0.uuid,
                        latitude: $0.geopoint.latitude,
                        longitude: $0.geopoint.longitude
                    )
                }

                owner.output.annotations.accept(annotations)

            })
            .disposed(by: disposeBag)
    }

    func fetchAnnotations() {
//        let coordinates: [CLLocationCoordinate2D] = [
//            CLLocationCoordinate2D(latitude: 37.582867, longitude: 126.027869),
//            CLLocationCoordinate2D(latitude: 37.402458, longitude: 127.028570),
//            CLLocationCoordinate2D(latitude: 37.583582861128654, longitude: 127.0205424855035),
//            CLLocationCoordinate2D(latitude: 37.581583861128454, longitude: 127.0306024855031),
//            CLLocationCoordinate2D(latitude: 37.587542861128354, longitude: 127.03933024855032),
//            CLLocationCoordinate2D(latitude: 37.583522861128547, longitude: 127.03813024855033),
//            CLLocationCoordinate2D(latitude: 37.583572861128602, longitude: 127.02753024855034),
//            CLLocationCoordinate2D(latitude: 37.583562861128644, longitude: 127.03953024855036),
//            CLLocationCoordinate2D(latitude: 37.584552861128254, longitude: 127.0153024855037),
//            CLLocationCoordinate2D(latitude: 37.589582861128354, longitude: 127.09053024855055)
//        ]
//
//        input.annotations.accept(coordinates)
    }
}
