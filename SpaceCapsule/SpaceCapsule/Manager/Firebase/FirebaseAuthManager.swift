//
//  FirebaseAuthManager.swift
//  SpaceCapsule
//
//  Created by 김민중 on 2022/11/17.
//
import CryptoKit
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

    func deleteAccount(completion: @escaping ((Error?) -> Void)) {
//        guard let uid = FirebaseAuthManager.shared.currentUser?.uid else {
//            return
//        }
//        AppDataManager.shared.firestore.deleteUserCapsules()
//        AppDataManager.shared.firestore.deleteUserInfo(uid: uid) { error in
//            if let error = error {
//                print(error.localizedDescription)
//                completion(error)
//            } else {
//                AppDataManager.shared.capsules.accept([])
//                self.auth.currentUser?.delete()
//                completion(nil)
//            }
//        }
        makeJWT()
    }

    func makeJWT() {
        print(Payload().iat, Payload().exp)
        let secret = "your-256-bit-secret"
        let privateKey = SymmetricKey(data: Data(secret.utf8))

        guard let headerJSONData = try? JSONEncoder().encode(Header()),
              let payloadJSONData = try? JSONEncoder().encode(Payload()) else {
            print("JWT Error")
            return
        }
        
        let headerBase64String = headerJSONData.urlSafeBase64EncodedString()
        let payloadBase64String = payloadJSONData.urlSafeBase64EncodedString()

        let toSign = Data((headerBase64String + "." + payloadBase64String).utf8)

        let signature = HMAC<SHA256>.authenticationCode(for: toSign, using: privateKey)
        let signatureBase64String = Data(signature).urlSafeBase64EncodedString()

        let token = [headerBase64String, payloadBase64String, signatureBase64String].joined(separator: ".")
        print(token)
    }
}
