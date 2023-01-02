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

    func deleteImagesInCapsule(capsules: [Capsule]) -> Observable<Void> {
        return Observable.create { emitter in
            for capsule in capsules {
                capsule.images.forEach { [weak self] url in
                    self?.delete(forURL: url) { error in
                        if let error = error {
                            emitter.onError(FBStorageError.failedDeleteData)
                            return
                        }
                    }
                }
            }
            emitter.onCompleted()
            return Disposables.create()
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
