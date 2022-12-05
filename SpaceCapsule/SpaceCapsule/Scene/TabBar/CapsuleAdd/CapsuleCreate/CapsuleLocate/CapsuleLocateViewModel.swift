//
//  CapsuleLocateViewModel.swift
//  SpaceCapsule
//
//  Created by young june Park on 2022/11/15.
//

import Foundation
import RxCocoa
import RxSwift

final class CapsuleLocateViewModel: BaseViewModel {
    var disposeBag: DisposeBag = DisposeBag()
    var coordinator: CapsuleLocateCoordinator?

    var input = Input()
    var output = Output()

    struct Input: ViewModelInput {
        var done = PublishSubject<Void>()
        var cancel = PublishSubject<Void>()
        var isDragging = PublishRelay<Bool>()
    }

    struct Output: ViewModelOutput {
        var address = PublishSubject<Address>()
        var fullAddress = PublishRelay<String?>()
        var simpleAddress = PublishSubject<String>()
        var geopoint = PublishSubject<GeoPoint>()
        var doneButtonState = BehaviorRelay<Bool>(value: false)

        var locationObservable: Observable<(address: Address, geopoint: GeoPoint)> {
            Observable.combineLatest(address, geopoint) { address, geopoint in
                (address: address, geopoint: geopoint)
            }
        }
    }

    init() {
        bind()
    }

    func bind() {
        input.cancel
            .subscribe(onNext: { [weak self] in
                self?.coordinator?.finish()
            })
            .disposed(by: disposeBag)

        input.done
            .withLatestFrom(output.locationObservable)
            .subscribe(onNext: { [weak self] address, geopoint in
                self?.coordinator?.done(address: address, geopoint: geopoint)
            })
            .disposed(by: disposeBag)

        output.geopoint
            .subscribe(
                onNext: { [weak self] in
                    LocationManager.shared.reverseGeocode(point: $0) { address in
                        guard let address else {
                            self?.output.doneButtonState.accept(false)
                            self?.output.fullAddress.accept(LocationError.invalidGeopoint.localizedDescription)
                            return
                        }

                        self?.output.doneButtonState.accept(true)
                        self?.output.address.onNext(address)
                        self?.output.fullAddress.accept(address.full)
                        self?.output.simpleAddress.onNext(address.simple)
                    }
                },
                onError: { [weak self] error in
                    self?.output.doneButtonState.accept(false)
                    self?.output.fullAddress.accept(error.localizedDescription)
                }
            )
            .disposed(by: disposeBag)
    }
}
