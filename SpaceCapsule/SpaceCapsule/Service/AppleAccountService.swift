//
//  AppleAccountService.swift
//  SpaceCapsule
//
//  Created by young june Park on 2023/01/03.
//

import Foundation
import RxSwift

final class AppleAccountService {
    static let shared = AppleAccountService()

    private init() {}

    func execute<T: Decodable>(_ request: AppleAccountRequest, expecting type: T.Type) -> Observable<T> {
        return Observable.create { [weak self] emitter in
            guard let request = self?.request(from: request) else {
                return Disposables.create()
            }
            URLSession.shared.dataTask(with: request) { data, _, _ in
                guard let data = data else {
                    print(NetworkError.refreshTokenError.errorDescription)
                    emitter.onError(NetworkError.refreshTokenError)
                    return
                }
                guard let response = try? JSONDecoder().decode(type.self, from: data) else {
                    print(NetworkError.decodingError.errorDescription)
                    emitter.onError(NetworkError.refreshTokenError)
                    return
                }
                emitter.onNext(response)
                emitter.onCompleted()
            }.resume()

            return Disposables.create()
        }
    }
    func execute(_ request: AppleAccountRequest) -> Observable<Void> {
        return Observable.create { [weak self] emitter in
            guard let request = self?.request(from: request) else {
                return Disposables.create()
            }
            URLSession.shared.dataTask(with: request) { _, response, _ in
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
            }.resume()

            return Disposables.create()
        }
    }

    private func request(from aaRequest: AppleAccountRequest) -> URLRequest? {
        guard let url = aaRequest.url else {
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = aaRequest.httpMethod.text
        request.allHTTPHeaderFields = aaRequest.headerFields
        request.httpBody = aaRequest.requestBodyComponents.query?.data(using: .utf8)

        return request
    }
}
