//
//  NoneImageCache.swift
//  KingReceiver
//
//  Created by 장재훈 on 2022/11/20.
//

import Foundation

/// 캐싱 안할경우 그냥 ..
final class NoneImageCache: ImageCache {
    func fetch(with url: URL, completion: @escaping (Data?) -> Void) {
        fetchImageData(with: url, completion: completion)
    }
}
