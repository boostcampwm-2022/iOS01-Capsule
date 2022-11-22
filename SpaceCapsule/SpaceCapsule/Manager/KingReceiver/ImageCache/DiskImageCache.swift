//
//  DiskImageCache.swift
//  KingReceiver
//
//  Created by 장재훈 on 2022/11/20.
//

import Foundation

/// Caches 폴더에 이미지 캐싱
final class DiskImageCache: ImageCache {
    private let cacheDirectory: URL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]

    func fetch(with url: URL, completion: @escaping (Data?) -> Void) {
        DispatchQueue.global().async { [weak self] in
            guard let path = self?.path(for: url) else {
                completion(nil)
                return
            }
            
            if let data = try? Data(contentsOf: path) {
                completion(data)
                return
            }

            self?.fetchImageData(with: url, completion: { data in
                guard let data else {
                    completion(nil)
                    return
                }

                try? data.write(to: path)
                completion(data)
            })
        }
    }

    /// url 그대로 파일명 삼아 캐싱
    func path(for url: URL) -> URL {
        let fileName = url.absoluteString.replacingOccurrences(of: "/", with: "_")
        return cacheDirectory.appending(path: fileName)
    }
}
