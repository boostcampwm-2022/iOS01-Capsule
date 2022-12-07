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

final class HomeViewModel: BaseViewModel {
    weak var coordinator: HomeCoordinator?
    let disposeBag = DisposeBag()
    
    var input = Input()
    var output = Output()
    
    struct Input: ViewModelInput {
        var capsules = PublishRelay<[Capsule]>()
    }
    
    struct Output: ViewModelOutput {
        var mainLabelText = PublishRelay<String>()
        var featuredCapsuleCellItems = PublishRelay<[HomeCapsuleCellItem]>()
    }
    
    init() {
        bind()
    }
    
    func bind() {
        input.capsules
            .withUnretained(self)
            .subscribe(
                onNext: { owner, capsuleList in
                    owner.output.mainLabelText.accept(owner.makeMainLabel(capsuleCount: capsuleList.count))
                    if capsuleList.isEmpty {
                        return
                    }
                    owner.output.featuredCapsuleCellItems.accept(
                        CapsuleType.allCases
                            .map { owner.getHomeCapsuleCellItem(capsules: capsuleList, type: $0) }
                            .compactMap({ $0 })
                    )
                    
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
    
    func makeMainLabel(capsuleCount: Int) -> String {
        let nickname = UserDefaultsManager<UserInfo>.loadData(key: .userInfo)?.nickname ?? "none"
        return "\(nickname)님의 공간캡슐 \(capsuleCount)개"
    }
    
    func getHomeCapsuleCellItem(capsules: [Capsule], type: CapsuleType) -> HomeCapsuleCellItem? {
        switch type {
        case .closedOldest:
            let capsule = getClosedOldest(capsules: capsules)
            return makeHomeCapsuleCellItem(capsule: capsule, type: type)
        case .closedNewest:
            let capsule = getClosedNewest(capsules: capsules)
            return makeHomeCapsuleCellItem(capsule: capsule, type: type)
        case .memoryOldest:
            let capsule = getMemoryOldest(capsules: capsules)
            return makeHomeCapsuleCellItem(capsule: capsule, type: type)
        case .memoryNewest:
            let capsule = getMemoryNewest(capsules: capsules)
            return makeHomeCapsuleCellItem(capsule: capsule, type: type)
        case .nearest:
            let capsule = getNearest(capsules: capsules)
            return makeHomeCapsuleCellItem(capsule: capsule, type: type)
        case .farthest:
            let capsule = getFarthest(capsules: capsules)
            return makeHomeCapsuleCellItem(capsule: capsule, type: type)
        case .leastOpened:
            let capsule = getLeastOpened(capsules: capsules)
            return makeHomeCapsuleCellItem(capsule: capsule, type: type)
        }
    }
    
    func makeHomeCapsuleCellItem(capsule: Capsule?, type: CapsuleType) -> HomeCapsuleCellItem? {
        guard let capsule else {
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
    
    func getClosedOldest(capsules: [Capsule]) -> Capsule? {
        return capsules.min { $0.closedDate < $1.closedDate }
    }
    func getClosedNewest(capsules: [Capsule]) -> Capsule? {
        return capsules.max { $0.closedDate < $1.closedDate }
    }
    func getMemoryOldest(capsules: [Capsule]) -> Capsule? {
        return capsules.min { $0.memoryDate < $1.memoryDate }
    }
    func getMemoryNewest(capsules: [Capsule]) -> Capsule? {
        return capsules.max { $0.memoryDate < $1.memoryDate }
    }
    func getNearest(capsules: [Capsule]) -> Capsule? {
        return capsules.min { first, second in
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
    }
    func getFarthest(capsules: [Capsule]) -> Capsule? {
        return capsules.max { first, second in
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
    }
    func getLeastOpened(capsules: [Capsule]) -> Capsule? {
        return capsules.min(by: { $0.openCount < $1.openCount })
    }
}
