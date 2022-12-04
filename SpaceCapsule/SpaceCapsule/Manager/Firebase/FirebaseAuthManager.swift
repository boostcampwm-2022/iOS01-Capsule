//
//  FirebaseAuthManager.swift
//  SpaceCapsule
//
//  Created by 김민중 on 2022/11/17.
//

import FirebaseAuth
import Foundation

class FirebaseAuthManager {
    static let shared = FirebaseAuthManager()
    let auth = Auth.auth()

    var currentUser: User? {
        return auth.currentUser
    }

    private init() { }

    func initCredential(withProviderID: String, idToken: String, rawNonce: String) -> OAuthCredential {
        return OAuthProvider.credential(withProviderID: withProviderID, idToken: idToken, rawNonce: rawNonce)
    }

    func signIn(with: AuthCredential, completion: @escaping ((AuthDataResult?, Error?) -> Void?)) {
        auth.signIn(with: with)
    }

    func signOut(completion: @escaping ((Error?) -> Void?)) {
        do {
            try auth.signOut()
        } catch let signOutError as NSError {
            completion(signOutError)
        }
    }

    func withdrawal(completion: @escaping ((Error?) -> Void?)) {
        guard let uid = FirebaseAuthManager.shared.currentUser?.uid else {
            return
        }
        AppDataManager.shared.firestore.deleteUserCapsules()
        AppDataManager.shared.firestore.deleteUserInfo(uid: uid) { error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
        }
        auth.currentUser?.delete()
    }
}
