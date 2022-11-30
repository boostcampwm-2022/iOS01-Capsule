//
//  AppDataManager.swift
//  SpaceCapsule
//
//  Created by 장재훈 on 2022/11/29.
//

import Foundation
import RxCocoa
import RxSwift

final class AppDataManager {
    static let shared = AppDataManager()

    private init() {
        fetchCapsules()
    }

    let disposeBag = DisposeBag()

    let firestore = FirestoreManager.shared
    let auth = FirebaseAuthManager.shared
    let location = LocationManager.shared

    let capsules = BehaviorRelay<[Capsule]>(value: [])

    func fetchCapsules() {
        guard let uid = auth.currentUser?.uid else {
            return
        }
        
        firestore.fetchCapsuleList(of: uid)
            .withUnretained(self)
            .subscribe(onNext: { owner, capsules in
                owner.capsules.accept(capsules)
            })
            .disposed(by: disposeBag)
    }
}
