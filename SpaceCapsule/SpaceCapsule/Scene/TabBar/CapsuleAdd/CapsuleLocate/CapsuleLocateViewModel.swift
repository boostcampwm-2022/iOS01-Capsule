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
            .withLatestFrom(output.address)
            .subscribe(onNext: { [weak self] in
                self?.coordinator?.done(address: $0)
            })
            .disposed(by: disposeBag)
    }

    func fetchLocation(x: Double, y: Double) {
        do {
            let locationRequest = try KakaoAPIManager.shared.getRequest(for: .coordToAddress((x: String(x), y: String(y))))

            let observable: Observable<Result<KakaoResponse, NetworkError>> = NetworkManager.shared.send(request: locationRequest)

            observable
                .map { result -> [Document] in
                    switch result {
                    case let .success(value):
                        return value.documents

                    case let .failure(error):
                        print(error)
                        return []
                    }
                }
                .observe(on: MainScheduler())
                .subscribe(onNext: { [weak self] in
                    let address = $0.first?.address

                    if let address {
                        self?.output.address.onNext(address)
                    }

                    self?.output.fullAddress.accept(address?.addressName)
                    self?.output.simpleAddress.onNext("\(address?.region1DepthName ?? "") \(address?.region2DepthName ?? "")")
                })
                .disposed(by: disposeBag)
        } catch {
            print(error)
        }
    }
}
