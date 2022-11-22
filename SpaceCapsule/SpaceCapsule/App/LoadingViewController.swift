//
//  LoadingViewController.swift
//  SpaceCapsule
//
//  Created by 김민중 on 2022/11/21.
//

import UIKit

final class LoadingViewController: UIViewController {
    // MARK: - Properties
    private let loadingView = LoadingView()
    
    // MARK: - Lifecycles
    override func loadView() {
        view = loadingView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
