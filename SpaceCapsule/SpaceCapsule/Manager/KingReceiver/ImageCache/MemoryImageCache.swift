//
//  MemoryImageCache.swift
//  KingReceiver
//
//  Created by 장재훈 on 2022/11/20.
//

import Foundation

/// 메모리 -> `NSCache` 에 캐싱
final class MemoryImageCache: ImageCache {
    private let cache = NSCache<NSString, NSData>()

    init(cacheLimit: Int = 52428800) {
        cache.totalCostLimit = cacheLimit
    }

    func fetch(with url: URL, completion: @escaping (Data?) -> Void) {
        if let data = cache[url] {
            completion(data as Data)
            return
        }

        fetchImageData(with: url) { [weak self] data in
            guard let data else {
                completion(nil)
                return
            }

            self?.save(data: data, with: url)
            completion(data)
        }
    }

    func save(data: Data, with url: URL) {
        cache[url] = data as NSData
    }
}
