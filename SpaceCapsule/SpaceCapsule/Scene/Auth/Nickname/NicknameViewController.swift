//
//  NicknameViewController.swift
//  SpaceCapsule
//
//  Created by young june Park on 2022/11/15.
//

import UIKit
import RxSwift
import FirebaseAuth

final class NicknameViewController: UIViewController, BaseViewController {
    // MARK: - Properties
    private let nicknameView = NicknameView()
    var viewModel: NickNameViewModel?
    var disposeBag = DisposeBag()
    
    // MARK: - Lifecycles
    override func loadView() {
        view = nicknameView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    // MARK: - Rx
    func bind() {
        guard let viewModel else { return }
        
        nicknameView
            .nicknameTextField.rx.text
            .orEmpty
            .bind(to: viewModel.input.nickname)
            .disposed(by: disposeBag)
        
        nicknameView
            .doneButton.rx.tap
            .bind(to: viewModel.input.doneButtonTapped)
            .disposed(by: disposeBag)
        
        // MARK: 이건 지워도 될 듯?
        viewModel.input
            .doneButtonTapped
            .bind(onNext: {
                
            })
            .disposed(by: disposeBag)
    }
}
