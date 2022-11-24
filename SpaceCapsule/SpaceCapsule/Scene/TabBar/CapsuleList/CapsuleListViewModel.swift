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
    private let capsuleCellModels: [CapsuleCellModel] = [
        CapsuleCellModel(uuid: UUID(),
                         thumbnailImage: .logoWithText,
                         address: "서울시 광진구",
                         closedDate: "2017년 1월 1일",
                         memoryDate: "2017년 1월 1일",
                         isOpenable: true,
                         coordinate: CLLocationCoordinate2D(latitude: 37.582897, longitude: 126.027169)
                        ),
        CapsuleCellModel(uuid: UUID(),
                         thumbnailImage: .logoWithText,
                         address: "서울시 동작구",
                         closedDate: "2018년 3월 3일",
                         memoryDate: "2018년 3월 3일",
                         isOpenable: true,
                         coordinate: CLLocationCoordinate2D(latitude: 37.582817, longitude: 126.027839)
                        ),
        CapsuleCellModel(uuid: UUID(),
                         thumbnailImage: .logoWithText,
                         address: "서울시 영등포구",
                         closedDate: "2019년 7월 2일",
                         memoryDate: "2019년 7월 2일",
                         isOpenable: false,
                         coordinate: CLLocationCoordinate2D(latitude: 37.582857, longitude: 126.027889)
                        ),
        CapsuleCellModel(uuid: UUID(),
                         thumbnailImage: .logoWithText,
                         address: "서울시 동대문구",
                         closedDate: "2017년 12월 16일",
                         memoryDate: "2017년 12월 16일",
                         isOpenable: true,
                         coordinate: CLLocationCoordinate2D(latitude: 37.582167, longitude: 126.027369)
                        ),
        CapsuleCellModel(uuid: UUID(),
                         thumbnailImage: .logoWithText,
                         address: "서울시 은평구",
                         closedDate: "2019년 10월 11일",
                         memoryDate: "2019년 10월 11일",
                         isOpenable: false,
                         coordinate: CLLocationCoordinate2D(latitude: 37.582267, longitude: 126.026869)
                        ),
        CapsuleCellModel(uuid: UUID(),
                         thumbnailImage: .logoWithText,
                         address: "서울시 구로구",
                         closedDate: "2016년 11월 11일",
                         memoryDate: "2016년 11월 11일",
                         isOpenable: true,
                         coordinate: CLLocationCoordinate2D(latitude: 37.581867, longitude: 126.027869)
                        ),
        CapsuleCellModel(uuid: UUID(),
                         thumbnailImage: .logoWithText,
                         address: "서울시 강서구",
                         closedDate: "2015년 5월 11일",
                         memoryDate: "2015년 5월 11일",
                         isOpenable: false,
                         coordinate: CLLocationCoordinate2D(latitude: 37.582167, longitude: 126.027069)
                        ),
        CapsuleCellModel(uuid: UUID(),
                         thumbnailImage: .logoWithText,
                         address: "서울시 강동구",
                         closedDate: "2022년 11월 10일",
                         memoryDate: "2022년 11월 10일",
                         isOpenable: false,
                         coordinate: CLLocationCoordinate2D(latitude: 37.585867, longitude: 126.025869)
                        ),
        CapsuleCellModel(uuid: UUID(),
                         thumbnailImage: .logoWithText,
                         address: "서울시 용산구",
                         closedDate: "2015년 11월 10일",
                         memoryDate: "2015년 11월 10일",
                         isOpenable: true,
                         coordinate: CLLocationCoordinate2D(latitude: 37.582817, longitude: 126.027860)
                        ),
        CapsuleCellModel(uuid: UUID(),
                         thumbnailImage: .logoWithText,
                         address: "서울시 관악구",
                         closedDate: "2022년 11월 9일",
                         memoryDate: "2022년 11월 9일",
                         isOpenable: true,
                         coordinate: CLLocationCoordinate2D(latitude: 37.582897, longitude: 126.027069)
                        ),
        CapsuleCellModel(uuid: UUID(),
                         thumbnailImage: .logoWithText,
                         address: "서울시 서초구",
                         closedDate: "2022년 11월 8일",
                         memoryDate: "2022년 11월 8일",
                         isOpenable: false,
                         coordinate: CLLocationCoordinate2D(latitude: 37.583867, longitude: 126.029869)
                        )
    ]
    var input = Input()

    struct Input {
        var capsuleCellModels = PublishSubject<[CapsuleCellModel]>()
        var sortPolicy = PublishSubject<SortPolicy>()
    }

    init() {
        bind()
    }

    private func bind() {}
    
    func fetchCapsules() {
        input.capsuleCellModels.onNext(capsuleCellModels)
    }
    
    func sort(capsuleCellModels: [CapsuleCellModel], by sortPolicy: SortPolicy) {
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
                $0.dateToInt() > $1.dateToInt()
            }
        case .oldest:
            models = capsuleCellModels.sorted {
                $0.dateToInt() < $1.dateToInt()
            }
        }
        input.capsuleCellModels.onNext(models)
    }
}
