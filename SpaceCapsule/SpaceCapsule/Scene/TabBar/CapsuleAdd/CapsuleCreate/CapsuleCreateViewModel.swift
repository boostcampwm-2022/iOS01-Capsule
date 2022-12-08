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

    lazy var capsuleDataObservable: Observable<Capsule> = {
        Observable.combineLatest(
            input.title.asObservable(),
            input.description.asObservable(),
            input.imageUrlArray.asObservable(),
            output.address.asObservable(),
            output.geopoint.asObservable(),
            output.memoryDate.asObservable()
        ) { title, description, urlArray, address, geopoint, date in
            Capsule(
                userId: FirebaseAuthManager.shared.currentUser?.uid ?? "",
                images: urlArray,
                title: title,
                description: description,
                address: address.full,
                simpleAddress: address.simple,
                geopoint: geopoint,
                memoryDate: date,
                openCount: 0
            )
        }
    }()

    lazy var isFieldValid: Observable<Bool> = {
        Observable.combineLatest(
            input.title.asObservable(),
            input.description.asObservable(),
            input.imageData.asObservable()
        ) { title, description, imageData in
            !title.isEmpty && !description.isEmpty && imageData.count > 1
        }
    }()

    struct Input {
        var tapClose = PublishSubject<Void>()
        var tapDone = PublishSubject<Void>()
        var tapDatePicker = PublishSubject<Void>()
        var tapCapsuleLocate = PublishSubject<Void>()
        var tapImage = PublishSubject<Int>()

        var title = PublishSubject<String>()
        var description = PublishSubject<String>()

        var imageData = BehaviorRelay<[AddImageCollectionView.Cell]>(value: [.addButton])
        var imageUrlDict = BehaviorSubject<[Int: URL]>(value: [:])
        var imageUrlArray = PublishSubject<[String]>()
    }

    struct Output {
        let indicatorState = BehaviorSubject<Bool>(value: false)
        var address = PublishSubject<Address>()
        var geopoint = PublishSubject<GeoPoint>()
        var memoryDate = BehaviorSubject<Date>(value: Date())
    }

    init() {
        bind()
    }

    private func bind() {
        input.imageUrlDict
            .subscribe(onNext: { [weak self] dict in
                if dict.count == self?.input.imageData.value.compactMap({ $0.data }).count {
                    let sortedArray = dict
                        .sorted(by: { $0.key < $1.key })
                        .compactMap { $0.value.absoluteString }

                    self?.input.imageUrlArray.onNext(sortedArray)
                }
            })
            .disposed(by: disposeBag)

        input.imageUrlArray
            .withLatestFrom(capsuleDataObservable)
            .withUnretained(self)
            .subscribe(onNext: { weakSelf, capsule in
                guard let uid = FirebaseAuthManager.shared.currentUser?.uid else {
                    return
                }

                FirestoreManager.shared.uploadCapsule(uid: uid, capsule: capsule) { error in
                    weakSelf.output.indicatorState.onNext(false)

                    guard error == nil else {
                        return
                    }

                    weakSelf.coordinator?.showCapsuleClose(capsule: capsule)
                }
            })
            .disposed(by: disposeBag)

        bindInput()
        bindOutput()
    }

    private func bindOutput() {
        // 로딩 indicator
        output.indicatorState
            .withUnretained(self)
            .subscribe(onNext: { weakSelf, state in
                guard let coordinator = weakSelf.coordinator else {
                    return
                }

                if state {
                    coordinator.startIndicator()
                } else {
                    coordinator.stopIndicator()
                }
            })
            .disposed(by: disposeBag)
    }

    private func bindInput() {
        // 닫기
        input.tapClose.asObservable()
            .subscribe(onNext: { [weak self] in
                self?.coordinator?.finish()
            })
            .disposed(by: disposeBag)

        // 완료 버튼 클릭
        input.tapDone
            .withLatestFrom(input.imageData)
            .compactMap { $0.compactMap { $0.data } }
            .withUnretained(self)
            .subscribe(onNext: { weakSelf, data in
                weakSelf.output.indicatorState.onNext(true)

                data.enumerated().forEach { index, dataValue in
                    FirebaseStorageManager.shared.upload(data: dataValue)
                        .subscribe(onNext: { [weak self] in
                            guard let urlDictSubject = self?.input.imageUrlDict,
                                  var urlDict = try? urlDictSubject.value() else {
                                return
                            }

                            urlDict[index] = $0
                            urlDictSubject.onNext(urlDict)
                        })
                        .disposed(by: self.disposeBag)
                }
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

        // 사진 클릭
        input.tapImage
            .withUnretained(self)
            .subscribe(onNext: { owner, index in
                let dataArray = owner.input.imageData.value.compactMap { $0.data }

                owner.coordinator?.showDetailImage(index: index, dataArray: dataArray)
            })
            .disposed(by: disposeBag)
    }

    func addImage(orderedData: [Data]) {
        var imageValues = input.imageData.value

        if imageValues.count > 10 {
            return
        }

        orderedData.forEach { data in
            if !imageValues.compactMap({ $0.data }).contains(data) {
                imageValues.insert(contentsOf: [.image(data: data)], at: imageValues.count - 1)
                input.imageData.accept(imageValues)
            }
        }
    }

    func fetchAddress() {
        guard let coordinate = LocationManager.shared.coordinate else {
            return
        }

        let point = GeoPoint(latitude: coordinate.latitude, longitude: coordinate.longitude)

        LocationManager.shared.reverseGeocode(point: point) { [weak self] address in
            guard let address else {
                return
            }
            self?.output.address.onNext(address)
            self?.output.geopoint.onNext(point)
        }
    }
}
