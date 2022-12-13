//
//  FirebaseAuthManager.swift
//  SpaceCapsule
//
//  Created by 김민중 on 2022/11/17.
//
import CryptoKit
import FirebaseAuth
import Foundation
import SwiftJWT

final class FirebaseAuthManager {
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

    func deleteAccountFromFirestore(completion: @escaping ((FBAuthError?) -> Void)) {
        guard let uid = FirebaseAuthManager.shared.currentUser?.uid else {
            return
        }
        AppDataManager.shared.firestore.deleteUserCapsules()
        AppDataManager.shared.firestore.deleteUserInfo(uid: uid) { error in
            if error != nil {
                completion(FBAuthError.deleteUserFromFireStoreError)
            } else {
                completion(nil)
            }
        }
    }

    func deleteAccountFromAuth(completion: @escaping ((FBAuthError?) -> Void)) {
        AppDataManager.shared.capsules.accept([])
        auth.currentUser?.delete { error in
            if error != nil {
                completion(FBAuthError.deleteUserFromAuthError)
            } else {
                completion(nil)
            }
        }
    }

    private func clientSecret() -> String? {
        guard let privateKey =
            """
            -----BEGIN PRIVATE KEY-----
            MIGTAgEAMBMGByqGSM49AgEGCCqGSM49AwEHBHkwdwIBAQQgBu59KBTVAYoS7A9A
            SDr09NemKkFxu44brOzjfeo7YaGgCgYIKoZIzj0DAQehRANCAAS8nCVjRqbbQkU6
            w3jDMFAzLKYlZzWYN/QOS/hANnIOic1GMPKC2N98Fz4EDO52iWLsyl5pq7O3Wh2O
            79TSHEtE
            -----END PRIVATE KEY-----
            """.data(using: .utf8) else {
            return nil
        }

        var myJWT = JWT(claims: Payload())
        let jwtSigner = JWTSigner.es256(privateKey: privateKey)
        guard let signedJWT = try? myJWT.sign(using: jwtSigner) else {
            return nil
        }

        return signedJWT
    }

    func refreshToken(completion: @escaping ((String?) -> Void)) {
        guard let authorizationCode = UserDefaultsManager<String>.loadData(key: .authorizationCode),
              let url = URL(string: "https://appleid.apple.com/auth/token"),
              let clientSecret = clientSecret() else {
            return
        }
        let header: [String: String] = [
            "Content-Type": "application/x-www-form-urlencoded",
        ]
        var requestBodyComponents = URLComponents()
        requestBodyComponents.queryItems = [
            URLQueryItem(name: "code", value: authorizationCode),
            URLQueryItem(name: "client_id", value: "com.boostcamp.BoogieSpaceCapsule"),
            URLQueryItem(name: "client_secret", value: clientSecret),
            URLQueryItem(name: "grant_type", value: "authorization_code"),
        ]
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = header
        request.httpBody = requestBodyComponents.query?.data(using: .utf8)

        URLSession.shared.dataTask(with: request) { data, _, _ in
            guard let data = data else {
                print(NetworkError.refreshTokenError.errorDescription)
                completion(nil)
                return
            }
            guard let refreshTokenResponse = try? JSONDecoder().decode(RefreshTokenResponse.self, from: data),
                  let refreshToken = refreshTokenResponse.refreshToken else {
                print(NetworkError.decodingError.errorDescription)
                completion(nil)
                return
            }
            completion(refreshToken)
        }.resume()
    }

    func revokeToken(refreshToken: String, completion: @escaping ((NetworkError?) -> Void)) {
        guard let url = URL(string: "https://appleid.apple.com/auth/revoke"),
              let clientSecret = clientSecret() else {
            return
        }
        let header: [String: String] = [
            "Content-Type": "application/x-www-form-urlencoded",
        ]
        print("refresh", refreshToken)
        print("cli sec", clientSecret)
        var requestBodyComponents = URLComponents()
        requestBodyComponents.queryItems = [
            URLQueryItem(name: "token", value: refreshToken),
            URLQueryItem(name: "client_id", value: "com.boostcamp.BoogieSpaceCapsule"),
            URLQueryItem(name: "client_secret", value: clientSecret),
            URLQueryItem(name: "token_type_hint", value: "refresh_token"),
        ]
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = header
        request.httpBody = requestBodyComponents.query?.data(using: .utf8)

        let task = URLSession.shared.dataTask(with: request) { _, response, _ in
            guard let response = response as? HTTPURLResponse else {
                completion(NetworkError.revokeTokenError)
                return
            }
            if response.statusCode == 200 {
                completion(nil)
                return
            } else {
                completion(NetworkError.revokeTokenError)
                return
            }
        }
        task.resume()
    }
}
