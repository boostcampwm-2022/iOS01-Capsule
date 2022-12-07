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
        var capsules: BehaviorRelay<[Capsule]> = AppDataManager.shared.capsules
    }
    
    struct Output: ViewModelOutput {
        var capsuleCellItems = PublishRelay<[ListCapsuleCellItem]>()
    }
    
    init() {
        bind()
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
                    owner.output.capsuleCellItems.accept(capsuleCellItems)
                },
                onError: { error in
                    print(error.localizedDescription)
                }
            )
            .disposed(by: disposeBag)
    }
    
    func bind() {
    }
}
