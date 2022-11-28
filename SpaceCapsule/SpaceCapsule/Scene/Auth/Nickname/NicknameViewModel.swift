//
//  NicknameViewModel.swift
//  SpaceCapsule
//
//  Created by young june Park on 2022/11/15.
//

import RxSwift
import RxCocoa

final class NickNameViewModel: BaseViewModel {
    weak var coordinator: NicknameCoordinator?
    let disposeBag = DisposeBag()
    
    var input = Input()
    var output = Output()
    
    struct Input: ViewModelInput {
        var nickname: PublishSubject = PublishSubject<String>()
        var doneButtonTapped: PublishSubject = PublishSubject<Void>()
    }
    
    struct Output: ViewModelOutput {
        var isRegistered: PublishSubject = PublishSubject<Bool>()
    }
    
    init(coordinator: NicknameCoordinator?) {
        self.coordinator = coordinator
        bind()
    }
    
    func bind() {
        // MARK: 굳이 둘로 나누어야 하나?
        // 닉네임 입력 후 회원가입 성공 시
        output.isRegistered
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { [weak self] isRegistered in
                if isRegistered {
                    UserDefaultsManager.saveData(data: true, key: .isRegistered)
                    self?.coordinator?.moveToTabBar()
                } else {
                    UserDefaultsManager.saveData(data: false, key: .isRegistered)
//                    self?.coordinator?.moveBackToSignIn()
                }
            })
            .disposed(by: disposeBag)
        
        // 완료 버튼 클릭 시
        input.doneButtonTapped
            .withLatestFrom(input.nickname)
            .subscribe(onNext: { nickname in
                guard let currentUser = FirebaseAuthManager.shared.currentUser else { return }
                let userInfo = UserInfo(email: currentUser.email, nickname: nickname)
                
                FirestoreManager.shared.registerUserInfo(uid: currentUser.uid, userInfo: userInfo) { [weak self] error in
                    if let error = error {
                        print("Error registering UserInfo: \(error)")
                        self?.output.isRegistered.onNext(false)
                    } else {
                        UserDefaultsManager.saveData(data: userInfo, key: .userInfo)
                        self?.output.isRegistered.onNext(true)
                    }
                }
            })
            .disposed(by: disposeBag)
    }
}
