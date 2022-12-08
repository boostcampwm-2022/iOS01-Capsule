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
    var input = Input()

    struct Input {
        var capsules: BehaviorRelay<[Capsule]> = AppDataManager.shared.capsules
        var capsuleCellItems = BehaviorRelay<[ListCapsuleCellItem]>(value: [])
        var sortPolicy = BehaviorRelay<SortPolicy>(value: .nearest)
        var refreshLoading = PublishRelay<Bool>()
        var viewWillAppear = PublishSubject<Void>()
    }

    init() {
        bind()
        fetchCapsuleList()
    }

    private func bind() {
        input.viewWillAppear
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.coordinator?.tabBarAppearance(isHidden: false)
            })
            .disposed(by: disposeBag)
    }
    
    func refreshCapsule() {
        AppDataManager.shared.fetchCapsules()
    }

    func fetchCapsuleList() {
        input.capsules
            .withUnretained(self)
            .subscribe(
                onNext: { owner, capsuleList in
                    let capsuleCellItems = capsuleList.map { capsule in
                        ListCapsuleCellItem(uuid: capsule.uuid,
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
                    owner.sort(capsuleCellItems: capsuleCellItems, by: owner.input.sortPolicy.value)
                },
                onError: { error in
                    print(error.localizedDescription)
                }
            )
            .disposed(by: disposeBag)
    }

    func sort(capsuleCellItems: [ListCapsuleCellItem], by sortPolicy: SortPolicy) {
        var items = capsuleCellItems
        switch sortPolicy {
        case .nearest:
            items = capsuleCellItems.sorted {
                $0.distance() < $1.distance()
            }
        case .furthest:
            items = capsuleCellItems.sorted {
                $0.distance() > $1.distance()
            }
        case .latest:
            items = capsuleCellItems.sorted {
                $0.memoryDate > $1.memoryDate
            }
        case .oldest:
            items = capsuleCellItems.sorted {
                $0.memoryDate < $1.memoryDate
            }
        }
        input.capsuleCellItems.accept(items)
    }
}
