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

}
