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
                    
                })
            .disposed(by: disposeBag)
    }
}
