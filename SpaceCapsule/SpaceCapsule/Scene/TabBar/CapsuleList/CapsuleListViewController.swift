//
//  CapsuleListViewController.swift
//  SpaceCapsule
//
//  Created by young june Park on 2022/11/15.
//

import UIKit
import RxSwift
import RxCocoa

final class CapsuleListViewController: UIViewController, BaseViewController {
    var disposeBag = DisposeBag()
    var viewModel: CapsuleListViewModel?
    
    let nextButton = UIBarButtonItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .secondarySystemBackground
        
        bind()
        
        // 임시
        nextButton.title = "다음"
        navigationItem.rightBarButtonItem = nextButton
        
    }
    
    func bind() {
        guard let viewModel else {return}
        // 임시
        nextButton.rx.tap
            .bind(to: viewModel.input.next)
            .disposed(by: disposeBag)
    }
}
