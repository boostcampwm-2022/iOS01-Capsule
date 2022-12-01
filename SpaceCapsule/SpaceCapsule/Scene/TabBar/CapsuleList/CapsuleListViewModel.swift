//
//  CapsuleListViewModel.swift
//  SpaceCapsule
//
//  Created by young june Park on 2022/11/15.
//

import CoreLocation
import Foundation
import RxCocoa
import RxSwift

final class CapsuleListViewModel: BaseViewModel {
    var disposeBag = DisposeBag()
    var coordinator: CapsuleListCoordinator?
    private let currentLocation = CLLocationCoordinate2D(latitude: 37.582867, longitude: 126.027869)
    var input = Input()

    struct Input {
        var capsuleCellModels = PublishSubject<[ListCapsuleCellModel]>()
        var sortPolicy = PublishSubject<SortPolicy>()
    }

    init() {
        bind()
    }

    private func bind() {}
    
    func fetchCapsuleList() {
        guard let currentUser = FirebaseAuthManager.shared.currentUser else {
            return
        }
      
        FirestoreManager.shared.fetchCapsuleList(of: currentUser.uid)
            .withUnretained(self)
            .subscribe(
            onNext: { owner, capsuleList in
                let capsuleCellModels = capsuleList.map { capsule in
                    return ListCapsuleCellModel(uuid: capsule.uuid,
                                                thumbnailImageURL: capsule.images.first,
                                                address: capsule.simpleAddress,
                                                closedDate: capsule.closedDate,
                                                memoryDate: capsule.memoryDate,
                                                coordinate: CLLocationCoordinate2D(
                                                    latitude: capsule.geopoint.latitude,
                                                    longitude: capsule.geopoint.longitude
                                                )
                    )
                }
                owner.input.capsuleCellModels.onNext(capsuleCellModels)
                owner.input.sortPolicy.onNext(.nearest)
            },
            onError: { error in
                print(error.localizedDescription)
            }
        )
        .disposed(by: disposeBag)
        
    }
    
    func sort(capsuleCellModels: [ListCapsuleCellModel], by sortPolicy: SortPolicy) {
        var models = capsuleCellModels
        switch sortPolicy {
        case .nearest:
            models = capsuleCellModels.sorted {
                $0.distance(from: currentLocation) < $1.distance(from: currentLocation)
            }
        case .furthest:
            models = capsuleCellModels.sorted {
                $0.distance(from: currentLocation) > $1.distance(from: currentLocation)
            }
        case .latest:
            models = capsuleCellModels.sorted {
                $0.memoryDate > $1.memoryDate
            }
        case .oldest:
            models = capsuleCellModels.sorted {
                $0.memoryDate < $1.memoryDate
            }
        }
        input.capsuleCellModels.onNext(models)
    }
}
