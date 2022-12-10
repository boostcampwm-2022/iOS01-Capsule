//
//  UserDefaultsManager.swift
//  SpaceCapsule
//
//  Created by 김민중 on 2022/11/19.
//

import Foundation

enum UserDefaultsKeys: String {
    case userInfo
    case isSignedIn
    case isRegistered
    case authorizationCode
}

class UserDefaultsManager<T: Codable> {
    static func saveData(data: T, key: UserDefaultsKeys) {
        guard let encodedData = try? JSONEncoder().encode(data) else {
            return
        }
        UserDefaults.standard.set(encodedData, forKey: key.rawValue)
    }

    static func loadData(key: UserDefaultsKeys) -> T? {
        guard let loadedData = UserDefaults.standard.object(forKey: key.rawValue) as? Data else {
            return nil
        }
        guard let decodedData = try? JSONDecoder().decode(T.self, from: loadedData) else {
            return nil
        }
        return decodedData
    }
}
