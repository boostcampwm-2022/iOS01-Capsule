//
//  NoneImageCache.swift
//  KingReceiver
//
//  Created by 장재훈 on 2022/11/20.
//

import Foundation

final class NoneImageCache: ImageCache {
    func fetch(with url: URL, completion: @escaping (Data?) -> Void) {
        fetchImageData(with: url, completion: completion)
    }
}
