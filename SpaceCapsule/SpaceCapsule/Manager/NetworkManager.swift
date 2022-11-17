//
//  NetworkManager.swift
//  SpaceCapsule
//
//  Created by jisu on 2022/11/17.
//

import Foundation

import RxSwift

final class NetworkManager {
    static let shared = NetworkManager()
    
    func send<T: Codable>(request: URLRequest) -> Observable<Result<T, CapsuleError>> {
        return URLSession.shared.rx.data(request: request)
            .map { data in
                do {
                    let response = try JSONDecoder().decode(T.self, from: data)
                    return .success(response)
                } catch {
                    return .failure(.decodingError)
                }
            }
    }
}
