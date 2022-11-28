//
//  CapsuleCreateViewModel.swift
//  SpaceCapsule
//
//  Created by young june Park on 2022/11/15.
//

import Foundation
import RxCocoa
import RxSwift

final class Capsule {
    let title: String
    let description: String

    init(title: String, description: String) {
        self.title = title
        self.description = description
    }
}

final class CapsuleCreateViewModel: BaseViewModel {
    var disposeBag = DisposeBag()
    var coordinator: CapsuleCreateCoordinator?

    var input = Input()
    var output = Output()

    struct Input {
        var close = PublishSubject<Void>()
        var done = PublishSubject<Void>()
        var imageData = BehaviorRelay<[AddImageCollectionView.Cell]>(value: [.addButton])
        var title = PublishSubject<String>()
        var description = PublishSubject<String>()

        var tapDatePicker = PublishSubject<Void>()
        var tapCapsuleLocate = PublishSubject<Void>()

        var capsuleDataObservable: Observable<Capsule> {
            Observable.combineLatest(title.asObservable(), description.asObservable()) { title, description in
                Capsule(title: title, description: description)
            }
        }
    }

    struct Output {
    }

    init() {
        bind()
    }

    private func bind() {
        // 닫기
        input.close.asObservable()
            .subscribe(onNext: { [weak self] in
                self?.coordinator?.finish()
            })
            .disposed(by: disposeBag)

        // 완료
        input.done
            .withLatestFrom(input.capsuleDataObservable)
//            .flatMapLatest { capsule in
//                capsule
//            }
            .subscribe(onNext: { event in
                print(event.title)
                print(event.description)
            })
            .disposed(by: disposeBag)

        // 날짜선택 클릭
        input.tapDatePicker.asObservable()
            .subscribe(onNext: { [weak self] in
                self?.coordinator?.showDatePicker()
            })
            .disposed(by: disposeBag)

        // 위치선택 클릭
        input.tapCapsuleLocate.asObservable()
            .subscribe(onNext: { [weak self] in
                self?.coordinator?.showCapsuleLocate()
            })
            .disposed(by: disposeBag)
        
        // address Observable in coordinator
    }

    func addImage(data: Data) {
        let imageValues = input.imageData.value

        if !imageValues.compactMap({ $0.data }).contains(data) {
            input.imageData.accept([.image(data: data)] + imageValues)
        }
    }
}
