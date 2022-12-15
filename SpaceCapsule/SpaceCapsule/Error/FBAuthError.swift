//
//  FirebaseAuthError.swift
//  SpaceCapsule
//
//  Created by 장재훈 on 2022/11/23.
//

import Foundation

enum FBAuthError: LocalizedError {
    case noSnapshot
    case decodeError
    case deleteUserFromFireStoreError
    case deleteUserFromAuthError

    var errorDescription: String {
        switch self {
        case .noSnapshot:
            return "No Snapshot"
        case .decodeError:
            return "No Field"
        case .deleteUserFromFireStoreError:
            return "deleteUserFromFireStoreError"
        case .deleteUserFromAuthError:
            return "deleteUserFromAuthError"
        }
    }
}
