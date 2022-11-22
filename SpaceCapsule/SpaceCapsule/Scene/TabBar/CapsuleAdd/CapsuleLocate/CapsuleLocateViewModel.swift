//
//  CapsuleLocateViewModel.swift
//  SpaceCapsule
//
//  Created by young june Park on 2022/11/15.
//

import CoreLocation
import Foundation
import RxCocoa
import RxSwift

final class CapsuleLocateViewModel: BaseViewModel {
    var disposeBag: DisposeBag = DisposeBag()
    var coordinator: CapsuleLocateCoordinator?

    var input = Input()
    var output = Output()

    struct Input: ViewModelInput {
        var fixedCoordinate = PublishRelay<CLLocationCoordinate2D>()
        var isDragging = PublishRelay<Bool>()
    }

    struct Output: ViewModelOutput {}

    init() {
        bind()
    }

    func bind() {}
}
