//
//  DetailImageViewModel.swift
//  SpaceCapsule
//
//  Created by 장재훈 on 2022/12/06.
//

import Foundation
import RxSwift

enum ImageSource: Hashable {
    case data(value: Data)
    case url(value: String)

    var dataValue: Data? {
        switch self {
        case let .data(value): return value
        default: return nil
        }
    }

    var urlValue: String? {
        switch self {
        case let .url(value): return value
        default: return nil
        }
    }
}

final class DetailImageViewModel: BaseViewModel {
    var disposeBag = DisposeBag()
    var coordinator: DetailImageCoordinator?

    let input = Input()
    let output = Output()

    struct Input {
        let tapClose = PublishSubject<Void>()
    }

    struct Output {
//        let imageData = PublishSubject<(data: [Data], index: Int)>()
//        let urlData = PublishSubject<(data: [String], index: Int)>()

        let imageSources = PublishSubject<(sources: [ImageSource], index: Int)>()
    }

    init() {
        bind()
    }

    private func bind() {
        input.tapClose
            .subscribe(onNext: { [weak self] in
                self?.coordinator?.finish()
            })
            .disposed(by: disposeBag)
    }

    func fetchData() {
        guard let index = coordinator?.index else {
            return
        }

        if let dataArray = coordinator?.dataArray {
            let sources = dataArray.map { ImageSource.data(value: $0) }
            output.imageSources.onNext((sources: sources, index: index))
        }

        if let urlArray = coordinator?.urlArray {
            let sources = urlArray.map { ImageSource.url(value: $0) }
            output.imageSources.onNext((sources: sources, index: index))
        }
    }
}
