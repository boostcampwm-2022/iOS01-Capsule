//
//  FirebaseStorageError.swift
//  SpaceCapsule
//
//  Created by 장재훈 on 2022/11/23.
//

import Foundation

enum FBStorageError: LocalizedError {
    case failedPutData
    case failedDownloadURL
    
    var errorDescription: String {
        switch self {
        case .failedPutData:
            return "데이터 업로드 실패"
        case .failedDownloadURL:
            return "데이터 URL 다운로드 실패"
        }
    }
}
