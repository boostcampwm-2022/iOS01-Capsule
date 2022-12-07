//
//  CapsuleSettingsViewController.swift
//  SpaceCapsule
//
//  Created by jisu on 2022/12/07.
//

import UIKit
import RxSwift

final class CapsuleSettingsViewController: UIViewController, BaseViewController {
    var disposeBag = DisposeBag()
    var viewModel: CapsuleSettingsViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        
        if let sheetPresentationController {
            sheetPresentationController.detents = [.medium()]
            sheetPresentationController.prefersGrabberVisible = true
        }
    }
    
    func bind() {
        
    }
}
