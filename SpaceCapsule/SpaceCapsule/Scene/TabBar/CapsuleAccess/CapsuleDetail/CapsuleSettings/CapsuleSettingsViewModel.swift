//
//  CapsuleSettingsViewModel.swift
//  SpaceCapsule
//
//  Created by jisu on 2022/12/07.
//

import Foundation

import RxSwift

final class CapsuleSettingsViewModel: BaseViewModel {
    var disposeBag = DisposeBag()
    var coordinator: CapsuleSettingsCoordinator?
}
