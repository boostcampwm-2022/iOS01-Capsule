//
//  AppCoordinator.swift
//  SpaceCapsule
//
//  Created by young june Park on 2022/11/15.
//

import UIKit
import RxSwift

enum AuthFlow {
    case signInFlow
    case nicknameFlow
}

enum AuthError: LocalizedError {
    case noSnapshot
    case decodeError
    
    var errorDescription: String {
        switch self {
        case .noSnapshot:
            return "No Snapshot"
        case .decodeError:
            return "No Field"
        }
    }
}

final class AppCoordinator: Coordinator {
    var parent: Coordinator?
    var children: [Coordinator] = []
    var navigationController: UINavigationController?
    
    var window: UIWindow?
    
    let disposeBag = DisposeBag()
    
    // MARK: AppCoordinator가 Window를 관리
    init(window: UIWindow?) {
        self.window = window
    }
    
    func start() {
        // TODO: 첫 로딩화면 만들기
        let loadingViewController = UIViewController()
        loadingViewController.view.backgroundColor = .themeColor200
        window?.rootViewController = loadingViewController
        window?.makeKeyAndVisible()
        
        // MARK: Firebase signin/signout 과 Apple 로그인/로그아웃 상태
        guard let currentUser = FirebaseAuthManager.shared.currentUser,
              let isSignedIn = UserDefaultsManager<Bool>.loadData(key: .isSignedIn) else {
            moveToAuth(authFlow: .signInFlow)
            return
        }
        
        if isSignedIn {
            checkRegistration(uid: currentUser.uid)
        } else {
            moveToAuth(authFlow: .signInFlow)
        }
    }
    
    private func checkRegistration(uid: String) {
        guard let isRegistered = UserDefaultsManager<Bool>.loadData(key: .isRegistered) else {
            moveToAuth(authFlow: .nicknameFlow)
            return
        }
        
        if isRegistered {
            print("isRegistered: \(isRegistered)")
            moveToTabBar()
        } else {
            // TODO: 중복 구독하면 어떡하나?
            FirestoreManager.shared.fetchUserInfo(of: uid)
                .subscribe(
                    onNext: { [weak self] userInfo in
                        UserDefaultsManager.saveData(data: true, key: .isRegistered)
                        UserDefaultsManager.saveData(data: userInfo, key: .userInfo)
                        print(userInfo)
                        self?.moveToTabBar()
                    },
                    onError: { [weak self] _ in
                        UserDefaultsManager.saveData(data: false, key: .isRegistered)
                        self?.moveToAuth(authFlow: .nicknameFlow)
                    }
                )
                .disposed(by: self.disposeBag)
        }
    }
    
    func moveToAuth(authFlow: AuthFlow) {
        let navigationController = UINavigationController()
        let authCoordinator = AuthCoordinator(navigationController: navigationController)
        authCoordinator.parent = self
        authCoordinator.flow = authFlow
        authCoordinator.start()
        children.removeAll()
        children.append(authCoordinator)
        window?.rootViewController = navigationController
    }
    
    func moveToTabBar() {
        // TODO: 임시로 화면 전환한거임! 리팩토링 해야함!
        let tabBarViewController = HomeViewController()
        window?.rootViewController = tabBarViewController
        
        children.removeAll()
    }
    
}
