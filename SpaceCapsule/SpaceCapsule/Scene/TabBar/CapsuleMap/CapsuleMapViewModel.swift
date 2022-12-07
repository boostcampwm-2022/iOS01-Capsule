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
        let tapRefresh = PublishSubject<Void>()
        let tapCapsule = PublishSubject<String>()
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
                owner.updateAnnotations(capsules: capsules)
            })
            .disposed(by: disposeBag)

        input.tapRefresh
            .subscribe(onNext: { _ in
                AppDataManager.shared.fetchCapsules()
            })
            .disposed(by: disposeBag)

        input.tapCapsule
            .withUnretained(self)
            .subscribe(onNext: { owner, uuid in
                owner.coordinator?.moveToCapsuleAccess(uuid: uuid)
            })
            .disposed(by: disposeBag)
    }

    func updateAnnotations(capsules: [Capsule]) {
        let annotations = capsules.map {
            CustomAnnotation(
                uuid: $0.uuid,
                memoryDate: $0.memoryDate,
                latitude: $0.geopoint.latitude,
                longitude: $0.geopoint.longitude
            )
        }

        output.annotations.accept(annotations)
    }
}
