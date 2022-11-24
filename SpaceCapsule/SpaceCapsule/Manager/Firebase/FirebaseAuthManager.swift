//
//  FirebaseAuthManager.swift
//  SpaceCapsule
//
//  Created by 김민중 on 2022/11/17.
//

import Foundation
import FirebaseAuth

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
}