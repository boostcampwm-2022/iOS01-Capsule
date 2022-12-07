//
//  CapsuleSettingsViewModel.swift
//  SpaceCapsule
//
//  Created by jisu on 2022/12/07.
//

import Foundation

import RxSwift
import RxCocoa

final class CapsuleSettingsViewModel: BaseViewModel {
    typealias CapsuleUUID = String
    
    var disposeBag = DisposeBag()
    var coordinator: CapsuleSettingsCoordinator?
    
    var input = Input()
    var output = Output()
    
    init() {
        bind()
    }
    
    struct Input {
        var tapDelete = PublishRelay<Void>()
    }
    
    struct Output {
        var uuid = PublishSubject<CapsuleUUID>()
    }
    
    func bind() {
        input.tapDelete
            .subscribe(onNext: { [weak self] in
                if let uuid = self?.coordinator?.capsuleUUID {
                    self?.output.uuid.onNext(uuid)
                }
            })
            .disposed(by: disposeBag)
    }
}
