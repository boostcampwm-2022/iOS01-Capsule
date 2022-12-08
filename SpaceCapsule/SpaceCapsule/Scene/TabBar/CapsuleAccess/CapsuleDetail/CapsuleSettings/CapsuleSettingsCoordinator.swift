//
//  CapsuleSettingsCoordinator.swift
//  SpaceCapsule
//
//  Created by jisu on 2022/12/07.
//

import UIKit
import RxSwift

final class CapsuleSettingsCoordinator: Coordinator {
    var disposeBag = DisposeBag()
    var parent: Coordinator?
    var children: [Coordinator] = []
    var navigationController: CustomNavigationController?
    var capsuleUUID: String?
    
    var viewController: CapsuleSettingsViewController?
    
    init(navigationController: CustomNavigationController?) {
        self.navigationController = navigationController
    }
    
    func start() {
        viewController = CapsuleSettingsViewController()
        let capsuleSettingsViewModel = CapsuleSettingsViewModel()
        capsuleSettingsViewModel.coordinator = self
        viewController?.viewModel = capsuleSettingsViewModel
        
        capsuleSettingsViewModel.output.didDeleteCapsule
            .subscribe(onNext: { [weak self] in
                self?.finish()
            })
            .disposed(by: disposeBag)
        
        if let viewController {
            navigationController?.present(viewController, animated: true)
        }
    }
    
    func finish() {
        if let parent = parent as? CapsuleDetailCoordinator {
            viewController?.dismiss(animated: true)
            navigationController?.popViewController(animated: true)
            parent.finish()
        }
    }
}
