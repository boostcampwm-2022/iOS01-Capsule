//
//  HomeViewModel.swift
//  SpaceCapsule
//
//  Created by young june Park on 2022/11/15.
//

import CoreLocation
import Foundation
import RxCocoa
import RxSwift

final class HomeViewModel: BaseViewModel, CapsuleCellNeedable {
    struct UserCapsuleStatus {
        let nickname: String
        let capsuleCounts: Int
    }
    
    weak var coordinator: HomeCoordinator?
    let disposeBag = DisposeBag()

    var input = Input()
    var output = Output()

    struct Input: ViewModelInput {
        let capsules = PublishRelay<[Capsule]>()
        let tapCapsule = PublishSubject<String>()
        var viewWillAppear = PublishSubject<Void>()
    }

    struct Output: ViewModelOutput {
        let featuredCapsuleCellItems = PublishRelay<[HomeCapsuleCellItem]>()
        let userCapsuleStatus = PublishRelay<UserCapsuleStatus>()
    }

    init() {
        bind()
    }

    func bind() {
        input.viewWillAppear
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.coordinator?.tabBarAppearance(isHidden: false)
            })
            .disposed(by: disposeBag)
        
        input.capsules
            .withUnretained(self)
            .subscribe(
                onNext: { owner, capsuleList in
                    let nickname = UserDefaultsManager<UserInfo>.loadData(key: .userInfo)?.nickname ?? "none"
                    let status = UserCapsuleStatus(nickname: nickname, capsuleCounts: capsuleList.count)
                    owner.output.userInfo.accept(status)
                    
                    if capsuleList.isEmpty {
                        return
                    }
                    
                    owner.output.featuredCapsuleCellItems.accept(
                        CapsuleType.allCases.shuffled()
                            .map { owner.getHomeCapsuleCellItem(capsules: capsuleList, type: $0) }
                            .compactMap({ $0 })
                    )

                })
            .disposed(by: disposeBag)

        input.tapCapsule
            .withUnretained(self)
            .subscribe(onNext: { owner, uuid in
                guard let capsuleItemCell = owner.getCellItem(with: uuid) else {
                    return
                }
                owner.coordinator?.moveToCapsuleAccess(with: capsuleItemCell)
            })
            .disposed(by: disposeBag)

        AppDataManager.shared.capsules
            .withUnretained(self)
            .subscribe(
                onNext: { owner, capsuleList in
                    owner.input.capsules.accept(capsuleList)
                },
                onError: { error in
                    print(error.localizedDescription)
                }
            )
            .disposed(by: disposeBag)
    }

    private func getHomeCapsuleCellItem(capsules: [Capsule], type: CapsuleType) -> HomeCapsuleCellItem? {
        guard let capsule = getCapsule(in: capsules, by: type) else {
            return nil
        }
        
        return HomeCapsuleCellItem(
            uuid: capsule.uuid,
            thumbnailImageURL: capsule.images.first,
            address: capsule.simpleAddress,
            closedDate: capsule.closedDate,
            memoryDate: capsule.memoryDate,
            openCount: capsule.openCount,
            coordinate: CLLocationCoordinate2D(
                latitude: capsule.geopoint.latitude,
                longitude: capsule.geopoint.longitude
            ),
            type: type
        )
    }
    
    private func getCapsule(in capsules: [Capsule], by type: CapsuleType) -> Capsule? {
        switch type {
        case .closedLongest:
            return capsules.min { $0.closedDate < $1.closedDate }
        case .closedShortest:
            return capsules.max { $0.closedDate < $1.closedDate }
        case .memoryOldest:
            return capsules.min { $0.memoryDate < $1.memoryDate }
        case .memoryNewest:
            return capsules.max { $0.memoryDate < $1.memoryDate }
        case .nearest:
            return orderCapsulesByDistance(capsules).first
        case .farthest:
            return orderCapsulesByDistance(capsules).last
        case .leastOpened:
            return capsules.min(by: { $0.openCount < $1.openCount })
        }
    }
    
    private func orderCapsulesByDistance(_ capsules: [Capsule]) -> [Capsule] {
        let orderedCapsules = capsules.sorted { first, second in
            let firstLocation = CLLocationCoordinate2D(
                latitude: first.geopoint.latitude,
                longitude: first.geopoint.longitude
            )
            let secondLocation = CLLocationCoordinate2D(
                latitude: second.geopoint.latitude,
                longitude: second.geopoint.longitude
            )
            let firstDistance = LocationManager.shared.distance(capsuleCoordinate: firstLocation)
            let secondDistance = LocationManager.shared.distance(capsuleCoordinate: secondLocation)
            return firstDistance < secondDistance
        }
        return orderedCapsules
    }
}
