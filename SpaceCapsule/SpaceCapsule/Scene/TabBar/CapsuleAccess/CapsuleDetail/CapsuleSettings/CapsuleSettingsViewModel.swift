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
        var didDeleteCapsule = PublishRelay<Void>()
    }
    
    func bind() {
        input.tapDelete
            .subscribe(onNext: { [weak self] in
                if let uuid = self?.coordinator?.capsuleUUID {
                    FirestoreManager.shared.deleteCapsule(uuid)
                    AppDataManager.shared.fetchCapsules()
                    self?.output.didDeleteCapsule.accept(())
                }
            })
            .disposed(by: disposeBag)
    }
}
