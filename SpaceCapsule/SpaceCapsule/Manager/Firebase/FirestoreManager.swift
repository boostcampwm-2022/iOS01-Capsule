//
//  FirestoreManager.swift
//  SpaceCapsule
//
//  Created by 김민중 on 2022/11/17.
//

import FirebaseFirestore
import Foundation
import RxSwift

struct UserInfo: Codable {
    let email: String?
    let nickname: String?
}

class FirestoreManager {
    static let shared = FirestoreManager()
    private let database = Firestore.firestore()

    private init() { }

    func fetchUserInfo(of uid: String) -> Observable<UserInfo> {
        return Observable.create { emitter in
            self.database.collection("users").document(uid).getDocument { documentSnapshot, error in
                if let error = error {
                    print("Error getting document: \(error)")
                    emitter.onError(error)
                    return
                } else {
                    guard let snapshot = documentSnapshot?.data() else {
                        print("Error Snapshot: \(FBAuthError.noSnapshot)")
                        emitter.onError(FBAuthError.noSnapshot)
                        return
                    }
                    guard let userInfo = self.dictionaryToObject(type: UserInfo.self, dictionary: snapshot) else {
                        print("Error UserInfo: \(FBAuthError.decodeError)")
                        emitter.onError(FBAuthError.decodeError)
                        return
                    }
                    emitter.onNext(userInfo)
                    emitter.onCompleted()
                }
            }

            return Disposables.create { }
        }
    }

    private func dictionaryToObject<T: Decodable>(type: T.Type, dictionary: [String: Any]?) -> T? {
        guard let data = try? JSONSerialization.data(withJSONObject: dictionary as Any) else { return nil }
        guard let object = try? JSONDecoder().decode(T.self, from: data) else { return nil }
        return object
    }

    func registerUserInfo(uid: String, userInfo: UserInfo, completion: @escaping (Error?) -> Void) {
        guard let dict = userInfo.toDict else { return }

        database
            .collection("users")
            .document(uid)
            .setData(dict, merge: true) { error in
                if let error = error {
                    completion(error)
                } else {
                    completion(nil)
                }
            }
    }

    func uploadCapsule(uid: String, capsule: Capsule, completion: @escaping (Error?) -> Void) {
        database
            .collection("users")
            .document(uid)
            .updateData(["capsules": FieldValue.arrayUnion([capsule.uuid])]) { error in
//                if let error = error {
//                    completion(error)
//                } else {
//                    completion(nil)
//                }
            }

        guard let dict = capsule.toDict else { return }

        database
            .collection("capsules")
            .document(capsule.uuid)
            .setData(dict) { error in
                if let error = error {
                    completion(error)
                } else {
                    completion(nil)
                }
            }
    }
}
