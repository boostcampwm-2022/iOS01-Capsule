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
            .subscribe(onNext: { [weak self] in
                self?.fetchLocation(latitude: $0.latitude, longitude: $0.longitude)
            })
            .disposed(by: disposeBag)
    }

    func fetchLocation(latitude: Double, longitude: Double) {
        LocationManager.shared
            .reverseGeocode(with: GeoPoint(latitude: latitude, longitude: longitude))
            .subscribe(
                onNext: { [weak self] address in
                    self?.output.fullAddress.accept(address.full)
                    self?.output.simpleAddress.onNext(address.simple)
                },
                onError: { [weak self] error in
                    self?.output.fullAddress.accept(error.localizedDescription)
                }
            )
            .disposed(by: disposeBag)
    }
}
