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

    func fetch(with url: URL, completion: @escaping (Data?) -> Void) {
        let key = url.absoluteString as NSString

        if let data = cache.object(forKey: key) {
            completion(data as Data)
            return
        }

        fetchImageData(with: url) { [weak self] data in
            guard let data else {
                completion(nil)
                return
            }

            self?.save(data: data, with: key)
            completion(data)
        }
    }

    func save(data: Data, with key: NSString) {
        cache.setObject(data as NSData, forKey: key)
    }
}
