//
//  CapsuleCreateViewModel.swift
//  SpaceCapsule
//
//  Created by young june Park on 2022/11/15.
//

import Foundation
import RxCocoa
import RxSwift

final class CapsuleCreateViewModel: BaseViewModel {
    var disposeBag = DisposeBag()
    var coordinator: CapsuleCreateCoordinator?

    var input = Input()
    var output = Output()

    struct Input {
        var close = PublishSubject<Void>()
    }

    struct Output {
        // 임시 데이터 형식
        var imageData = BehaviorRelay<[AddImageCollectionView.Cell]>(value: [.addButton])
    }

    init() {
        bind()
    }

    private func bind() {
        input.close.asObservable()
            .subscribe(onNext: { [weak self] in
                self?.coordinator?.finish()
            })
            .disposed(by: disposeBag)
    }

    func addImage(data: Data) {
        let imageValues = output.imageData.value

        if !imageValues.compactMap({ $0.data }).contains(data) {
            output.imageData.accept([.image(data: data)] + imageValues)
        }
    }
}
