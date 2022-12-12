//
//  FirestoreManager.swift
//  SpaceCapsule
//
//  Created by 김민중 on 2022/11/17.
//

import FirebaseFirestore
import Foundation
import RxSwift

class FirestoreManager {
    static let shared = FirestoreManager()
    private init() { }

    private let database = Firestore.firestore()

    func fetchUserInfo(of uid: String) -> Observable<UserInfo> {
        return Observable.create { emitter in
            self.database
                .collection("users")
                .document(uid)
                .getDocument { documentSnapshot, error in
                    if let error = error {
                        emitter.onError(error)
                        return
                    } else {
                        guard let snapshot = documentSnapshot?.data() else {
                            emitter.onError(FBAuthError.noSnapshot)
                            return
                        }
                        guard let userInfo = self.dictionaryToObject(type: UserInfo.self, dictionary: snapshot) else {
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
        guard let data = try? JSONSerialization.data(withJSONObject: dictionary as Any),
              let object = try? JSONDecoder().decode(T.self, from: data) else {
            return nil
        }
        return object
    }

    private func dictionaryToCapsule(dictionary: [String: Any]?) -> Capsule? {
        guard let dict = dictionary,
              let capsule = Capsule(dictionary: dict) else {
            return nil
        }
        return capsule
    }

    func registerUserInfo(uid: String, userInfo: UserInfo, completion: @escaping (Error?) -> Void) {
        database
            .collection("users")
            .document(uid)
            .setData(userInfo.dictData, merge: true) { error in
                if let error = error {
                    completion(error)
                } else {
                    completion(nil)
                }
            }
    }

    func deleteUserInfo(uid: String, completion: @escaping ((Error?) -> Void)) {
        database
            .collection("users")
            .document(uid)
            .delete { error in
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
            .updateData(["capsules": FieldValue.arrayUnion([capsule.uuid])])

        database
            .collection("capsules")
            .document(capsule.uuid)
            .setData(capsule.dictData) { error in
                if let error = error {
                    completion(error)
                } else {
                    completion(nil)
                }
            }
    }

    func fetchCapsules(completion: @escaping ([Capsule]?) -> Void) {
        guard let uid = FirebaseAuthManager.shared.currentUser?.uid else {
            return
        }

        database
            .collection("capsules")
            .whereField("userId", isEqualTo: uid)
            .getDocuments { query, error in
                guard error == nil else {
                    completion(nil)
                    return
                }

                guard let documents = query?.documents else {
                    completion(nil)
                    return
                }

                let capsules = documents.compactMap {
                    self.dictionaryToCapsule(dictionary: $0.data())
                }

                completion(capsules)
            }
    }

    func deleteUserCapsules() {
        guard let uid = FirebaseAuthManager.shared.currentUser?.uid else {
            return
        }

        database
            .collection("users")
            .document(uid)
            .updateData(["capsules": []])

        database
            .collection("capsules")
            .whereField("userId", isEqualTo: uid)
            .getDocuments { snapshot, _ in
                snapshot?.documents.forEach {
                    self.database
                        .collection("capsules")
                        .document($0.documentID)
                        .delete()
                }
            }
    }

    func deleteCapsule(_ uuid: String, completion: @escaping ((Error?) -> Void)) {
        guard let uid = FirebaseAuthManager.shared.currentUser?.uid else {
            return
        }

        database
            .collection("users")
            .document(uid)
            .updateData([
                "capsules": FieldValue.arrayRemove([uuid]),
            ]) { error in
                if let error = error {
                    completion(error)
                }
            }

        database
            .collection("capsules")
            .document(uuid)
            .delete { error in
                if let error = error {
                    completion(error)
                } else {
                    completion(nil)
                }
            }
    }

    func incrementOpenCount(uuid: String) {
        database
            .collection("capsules")
            .document(uuid)
            .updateData([
                "openCount": FieldValue.increment(Int64(1)),
            ])
    }
}
