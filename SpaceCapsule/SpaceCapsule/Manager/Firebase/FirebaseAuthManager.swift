//
//  FirebaseAuthManager.swift
//  SpaceCapsule
//
//  Created by 김민중 on 2022/11/17.
//
import CryptoKit
import CryptorECC
import FirebaseAuth
import Foundation
import SwiftJWT

struct Header: Encodable {
    let alg = "ES256"
    let kid = "4979Z7MUXJ"
}

struct Payload: Claims {
    var iss = "4G6ZD4247R"
    var iat = Date().epochIATTimeStamp
    var exp = Date().epochEXPTimeStamp
    var aud = "https://appleid.apple.com"
    var sub = "com.boostcamp.BoogieSpaceCapsule"
}

struct RefreshTokenResponse: Decodable {
    let accessToken: String?
    let refreshToken: String?
    let idToken: String?

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        accessToken = try? values.decode(String.self, forKey: .accessToken)
        refreshToken = try? values.decode(String.self, forKey: .refreshToken)
        idToken = try? values.decode(String.self, forKey: .idToken)
    }

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case idToken = "id_token"
    }
}

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
        refreshToken { error in
            if let error = error {
                print(error.localizedDescription)
                completion(error)
            } else {
                guard let uid = FirebaseAuthManager.shared.currentUser?.uid else {
                    return
                }
                AppDataManager.shared.firestore.deleteUserCapsules()
                AppDataManager.shared.firestore.deleteUserInfo(uid: uid) { error in
                    if let error = error {
                        print(error.localizedDescription)
                        completion(error)
                    } else {
                        AppDataManager.shared.capsules.accept([])
                        self.auth.currentUser?.delete()
                        completion(nil)
                    }
                }
            }
        }
    }

    private func revokeToken(refreshToken: String, completion: @escaping ((Error?) -> Void)) {
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

        let task = URLSession.shared.dataTask(with: request) { _, response, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            if let response = response as? HTTPURLResponse {
                print(response.description)
                if response.statusCode == 200 {
                    completion(nil)
                    return
                } else {
                    completion(ECError.failedEvpInit) // TODO:
                    return
                }
            }
            if let error = error {
                print(error.localizedDescription)
                completion(error)
            } else {
                completion(nil)
            }
        }
        task.resume()
    }

    private func refreshToken(completion: @escaping ((Error?) -> Void)) {
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

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let response = response {
                print(response.description)
            }
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let data = data else {
                print("Empty data")
                return
            }
            guard let refreshTokenResponse = try? JSONDecoder().decode(RefreshTokenResponse.self, from: data),
                  let refreshToken = refreshTokenResponse.refreshToken else {
                print("decode Error")
                return
            }
            self.revokeToken(refreshToken: refreshToken) { error in
                if let error = error {
                    print(error.localizedDescription)
                    completion(error)
                } else {
                    completion(nil)
                }
            }
        }.resume()
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
}
