//
//  HomeViewController.swift
//  SpaceCapsule
//
//  Created by young june Park on 2022/11/15.
//

import UIKit
import RxSwift

final class HomeViewController: UIViewController, BaseViewController {
    var disposeBag = DisposeBag()
    var viewModel: HomeViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .themeColor300
    }
    
    func bind() {}
}
