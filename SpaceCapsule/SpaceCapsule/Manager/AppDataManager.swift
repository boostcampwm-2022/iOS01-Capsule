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
        firestore.fetchCapsules { data in
            guard let data else {
                return
            }
            self.capsules.accept(data)
        }
    }

    func capsule(uuid: String) -> Capsule? {
        return capsules.value.first(where: { $0.uuid == uuid })
    }
}
