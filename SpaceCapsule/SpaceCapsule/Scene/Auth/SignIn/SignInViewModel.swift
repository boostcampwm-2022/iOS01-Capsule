//
//  SignInViewModel.swift
//  SpaceCapsule
//
//  Created by young june Park on 2022/11/15.
//

import RxSwift
import RxCocoa

final class SignInViewModel: BaseViewModel {
    weak var coordinator: SignInCoordinator?
    let disposeBag = DisposeBag()
    
    var input = Input()
    var output = Output()
    
    struct Input: ViewModelInput {
        
    }
    
    struct Output: ViewModelOutput {
        
    }
    
    init(coordinator: SignInCoordinator?) {
        self.coordinator = coordinator
    }
    
    func checkRegistration(uid: String) {
        FirestoreManager.shared.fetchUserInfo(of: uid)
            .subscribe(
                onNext: { [weak self] userInfo in
                    UserDefaultsManager.saveData(data: true, key: .isRegistered)
                    UserDefaultsManager.saveData(data: userInfo, key: .userInfo)
                    self?.coordinator?.moveToTabBar()
                },
                onError: { [weak self] _ in
                    UserDefaultsManager.saveData(data: false, key: .isRegistered)
                    self?.coordinator?.moveToNickname()
                }
            )
            .disposed(by: self.disposeBag)
    }
}
