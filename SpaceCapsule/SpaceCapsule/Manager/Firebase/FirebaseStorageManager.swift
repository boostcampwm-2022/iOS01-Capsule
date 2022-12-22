//
//  FireStorageManager.swift
//  SpaceCapsule
//
//  Created by 장재훈 on 2022/11/22.
//

import FirebaseStorage
import Foundation
import RxSwift

final class FirebaseStorageManager {
    static let shared = FirebaseStorageManager()
    private init() {}

    private let storage = Storage.storage()

    func upload(data: Data) -> Observable<URL> {
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"

        let uid = FirebaseAuthManager.shared.currentUser?.uid ?? "unknownUser"
        let fileName = UUID().uuidString
        let firebaseReference = storage.reference().child("images/\(uid)/\(fileName)")

        return Observable.create { emitter in
            firebaseReference.putData(data, metadata: metadata) { _, error in
                guard error == nil else {
                    emitter.onError(FBStorageError.failedPutData)
                    return
                }
                firebaseReference.downloadURL { url, error in
                    guard error == nil, let url else {
                        emitter.onError(FBStorageError.failedDownloadURL)
                        return
                    }

                    emitter.onNext(url)
                }
            }

            return Disposables.create {}
        }
    }

    func downloadAuthP8(urlString: String, completion: @escaping (Data?) -> Void) {
        let storageReference = storage.reference(forURL: urlString)
        let megaByte = Int64(1 * 1024 * 1024)
        storageReference.getData(maxSize: megaByte) { data, _ in
            guard let data = data else {
                completion(nil)
                return
            }
            completion(data)
        }
    }

    func deleteImagesInCapsule(capsules: [Capsule], completion: @escaping (Error?) -> Void) {
        for capsule in capsules {
            capsule.images.forEach { url in
                delete(forURL: url) { error in
                    guard error != nil else {
                        completion(nil)
                        return
                    }
                    completion(FBStorageError.failedDeleteData)
                }
            }
        }
    }

    func delete(forURL: String, completion: @escaping (Error?) -> Void) {
        let storageReference = storage.reference(forURL: forURL)
        storageReference.delete { error in
            if let error = error {
                completion(FBStorageError.failedDeleteData)
                return
            }
            completion(nil)
        }
    }
}
