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
    private let database = Firestore.firestore()
    private init() { }

    var capsules: Observable<[Capsule]>?

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

    // TODO: FBAuthError 이름 바꾸기
    func fetchCapsuleList(of uid: String) -> Observable<[Capsule]> {
        return Observable.create { emitter in
            self.database
                .collection("capsules")
                .whereField("userId", isEqualTo: uid)
                .getDocuments { querySnapshot, error in
                    if let error = error {
                        print("Error Snapshot: \(error)")
                        emitter.onError(error)
                        return
                    } else {
                        guard let snapshots = querySnapshot?.documents else {
                            print("Error Snapshot: \(FBAuthError.noSnapshot)")
                            emitter.onError(FBAuthError.noSnapshot)
                            return
                        }

                        var capsuleList: [Capsule] = []

                        for snapshot in snapshots {
                            guard let capsule = self.dictionaryToCapsule(dictionary: snapshot.data()) else {
                                print("Error Capsule: \(FBAuthError.decodeError)")
                                emitter.onError(FBAuthError.decodeError)
                                return
                            }
                            capsuleList.append(capsule)
                        }

                        emitter.onNext(capsuleList)
                        // emitter.onCompleted() 이건 컴플리트 날릴 필요 없을 듯, 왜냐면 캡슐 목록 새로고침 기능 생길 가능성.
                    }
                }
            return Disposables.create { }
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
}
