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
        let capsules = PublishRelay<[Capsule]>()
        let tapCapsule = PublishSubject<String>()
        var viewWillAppear = PublishSubject<Void>()
    }

    struct Output: ViewModelOutput {
        let mainLabelText = PublishRelay<String>()
        let featuredCapsuleCellItems = PublishRelay<[HomeCapsuleCellItem]>()
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
                    owner.output.mainLabelText.accept(owner.makeMainLabel(capsuleCount: capsuleList.count))
                    if capsuleList.isEmpty {
                        return
                    }
                    owner.output.featuredCapsuleCellItems.accept(
                        CapsuleType.allCases.shuffled()
                            .map { owner.homeCapsuleCellItem(capsules: capsuleList, type: $0) }
                            .compactMap({ $0 })
                    )

                })
            .disposed(by: disposeBag)

        input.tapCapsule
            .withUnretained(self)
            .subscribe(onNext: { owner, uuid in
                owner.coordinator?.moveToCapsuleAccess(uuid: uuid)
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
        return "\(nickname)님이 생성한 공간캡슐 \(capsuleCount)개"
    }

    func homeCapsuleCellItem(capsules: [Capsule], type: CapsuleType) -> HomeCapsuleCellItem? {
        guard let capsule = type.capsule(from: capsules) else {
            return nil
        }

        return HomeCapsuleCellItem(
            uuid: capsule.uuid,
            thumbnailImageURL: capsule.images.first ?? "",
            address: capsule.simpleAddress,
            closedDate: capsule.closedDate,
            memoryDate: capsule.memoryDate,
            openCount: capsule.openCount,
            coordinate: capsule.geopoint.coordinate,
            type: type
        )
    }
}
