//
//  FirebaseAuthManager.swift
//  SpaceCapsule
//
//  Created by 김민중 on 2022/11/17.
//
import CryptoKit
import FirebaseAuth
import Foundation
import RxSwift
import SwiftJWT

final class FirebaseAuthManager {
    static let shared = FirebaseAuthManager()
    let auth = Auth.auth()
    let disposeBag = DisposeBag()

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

    func deleteAccountFromFirestore() -> Observable<Void> {
        return Observable.create { emitter in
            guard let uid = FirebaseAuthManager.shared.currentUser?.uid else {
                return Disposables.create()
            }
            AppDataManager.shared.firestore.deleteUserCapsules()
            AppDataManager.shared.firestore.deleteUserInfo(uid: uid) { error in
                if error != nil {
                    emitter.onError(FBAuthError.deleteUserFromFireStoreError)
                } else {
                    emitter.onNext(())
                    emitter.onCompleted()
                }
            }
            return Disposables.create()
        }
    }

    func deleteAccountFromAuth() -> Observable<Void> {
        return Observable.create { [weak self] emitter in
            guard let currentUser = self?.auth.currentUser else {
                return Disposables.create()
            }
            currentUser.delete { error in
                if error != nil {
                    emitter.onError(FBAuthError.deleteUserFromAuthError)
                } else {
                    emitter.onNext(())
                    emitter.onCompleted()
                }
            }
            return Disposables.create()
        }
    }

    private func clientSecret() -> String? {
        guard let privateKey = Bundle.main.authKey?.data(using: .utf8) else {
            return nil
        }
        var myJWT = JWT(claims: Payload())
        let jwtSigner = JWTSigner.es256(privateKey: privateKey)
        guard let signedJWT = try? myJWT.sign(using: jwtSigner) else {
            return nil
        }

        return signedJWT
    }

    func refreshToken() -> Observable<String> {
        return Observable.create { emitter in
            guard let authorizationCode = UserDefaultsManager<String>.loadData(key: .authorizationCode),
                  let clientSecret = self.clientSecret() else {
                emitter.onError(NetworkError.refreshTokenError)
                return Disposables.create()
            }
            let headerFields: [String: String] = [
                "Content-Type": "application/x-www-form-urlencoded",
            ]
            var requestBodyComponents = URLComponents()
            requestBodyComponents.queryItems = [
                URLQueryItem(name: "code", value: authorizationCode),
                URLQueryItem(name: "client_id", value: "com.boostcamp.BoogieSpaceCapsule"),
                URLQueryItem(name: "client_secret", value: clientSecret),
                URLQueryItem(name: "grant_type", value: "authorization_code"),
            ]
            var aaRequest = AppleAccountRequest(endPoint: .auth,
                                                pathComponents: ["token"],
                                                queryParameters: [],
                                                headerFields: headerFields,
                                                httpMethod: .post,
                                                requestBodyComponents: requestBodyComponents)

            AppleAccountService.shared.execute(aaRequest, expecting: RefreshTokenResponse.self).subscribe(
                onNext: { refreshTokenResponse in
                    if let refreshToken = refreshTokenResponse.refreshToken {
                        emitter.onNext(refreshToken)
                        emitter.onCompleted()
                    }
                },
                onError: { error in
                    emitter.onError(error)
                }
            ).disposed(by: self.disposeBag)

            return Disposables.create()
        }
    }

    func revokeToken(refreshToken: String) -> Observable<Void> {
        return Observable.create { [weak self] emitter in
            guard let url = URL(string: "https://appleid.apple.com/auth/revoke"),
                  let clientSecret = self?.clientSecret() else {
                return Disposables.create()
            }
            let header: [String: String] = [
                "Content-Type": "application/x-www-form-urlencoded",
            ]
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
                    emitter.onError(NetworkError.revokeTokenError)
                    return
                }
                if response.statusCode == 200 {
                    emitter.onNext(())
                    emitter.onCompleted()
                    return
                } else {
                    emitter.onError(NetworkError.revokeTokenError)
                    return
                }
            }
            task.resume()
            return Disposables.create()
        }
    }
}
