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
        var capsuleCellItems = PublishRelay<[HomeCapsuleCellItem]>()
        var mainLabelText = PublishRelay<String>()
        var featuredCcapsuleCellItems = PublishRelay<[HomeCapsuleCellItem]>()
    }
    
    init() {
        bind()
    }
    func fetchCapsuleList() {
        AppDataManager.shared.capsules
            .withUnretained(self)
            .subscribe(
                onNext: { owner, capsuleList in
                    let capsuleCellItems = capsuleList.map { capsule in
                        HomeCapsuleCellItem(uuid: capsule.uuid,
                                            thumbnailImageURL: capsule.images.first,
                                            address: capsule.simpleAddress,
                                            closedDate: capsule.closedDate,
                                            memoryDate: capsule.memoryDate,
                                            openCount: capsule.openCount,
                                            coordinate: CLLocationCoordinate2D(
                                                latitude: capsule.geopoint.latitude,
                                                longitude: capsule.geopoint.longitude
                                            ),
                                            type: .closedOldest
                        )
                    }
                    owner.input.capsules.accept(capsuleList)
                    owner.makeMainLabel(capsuleCount: capsuleList.count)
                    owner.output.capsuleCellItems.accept(capsuleCellItems)
                },
                onError: { error in
                    print(error.localizedDescription)
                }
            )
            .disposed(by: disposeBag)
    }
    
    func makeMainLabel(capsuleCount: Int) {
        let nickname = UserDefaultsManager<UserInfo>.loadData(key: .userInfo)?.nickname ?? "none"
        output.mainLabelText.accept("\(nickname)님의 공간캡슐 \(capsuleCount)개")
    }
    
    func bind() {
        input.capsules
            .withUnretained(self)
            .subscribe(
                onNext: { owner, capsuleList in
                    if capsuleList.isEmpty {
                        return
                    }
                    
                    
                })
            .disposed(by: disposeBag)
    }
    
    func getClosedOldest(capsules: [Capsule]) -> Capsule? {
//        capsules.sorted(by: { $0.closedDate < $1.closedDate }).first
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
        
    }
    func getFarthest(capsules: [Capsule]) -> Capsule? {
        
    }
    func getLeastOpened(capsules: [Capsule]) -> Capsule? {
        
    }
}
