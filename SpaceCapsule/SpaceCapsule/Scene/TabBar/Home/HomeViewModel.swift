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
        var capsuleCellModels = PublishSubject<[ListCapsuleCellItem]>()
    }
    
    struct Output: ViewModelOutput {
        
    }
    
    init() {
        bind()
    }
    func fetchCapsuleList() {
        guard let currentUser = FirebaseAuthManager.shared.currentUser else {
            return
        }
      
        FirestoreManager.shared.fetchCapsuleList(of: currentUser.uid)
            .withUnretained(self)
            .subscribe(
            onNext: { owner, capsuleList in
                let capsuleCellModels = capsuleList.map { capsule in
                    return ListCapsuleCellItem(uuid: capsule.uuid,
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
