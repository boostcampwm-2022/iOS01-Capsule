//
//  DetailImageViewModel.swift
//  SpaceCapsule
//
//  Created by 장재훈 on 2022/12/06.
//

import Foundation
import RxSwift

final class DetailImageViewModel: BaseViewModel {
    var disposeBag = DisposeBag()
    var coordinator: DetailImageCoordinator?

    let output = Output()

    struct Output {
        let imageData = PublishSubject<(data: [Data], index: Int)>()
    }

    init() {}

    func fetchData() {
        guard let index = coordinator?.index,
              let dataArray = coordinator?.dataArray else {
            return
        }
        
        output.imageData.onNext((data: dataArray, index: index))
    }
}
