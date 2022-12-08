//
//  NicknameViewController.swift
//  SpaceCapsule
//
//  Created by young june Park on 2022/11/15.
//

import FirebaseAuth
import RxSwift
import UIKit

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
        
        nicknameView
            .tapGesture.rx.event.bind(onNext: { [weak self] _ in
                self?.view.endEditing(true)
            })
            .disposed(by: disposeBag)
    }
}
