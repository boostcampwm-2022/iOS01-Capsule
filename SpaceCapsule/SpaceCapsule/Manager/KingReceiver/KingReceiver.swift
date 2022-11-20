//
//  KingReceiver.swift
//  KingReceiver
//
//  Created by 장재훈 on 2022/11/20.
//

import UIKit

/// Compatible Types 를 위한 Wrapper
/// 모듈의 메소드들을 편리하게 사용할 수 있도록 `.kr` 과 같은 방법 제공
struct KingReceiverWrapper<Base> {
    let base: Base

    init(_ base: Base) {
        self.base = base
    }
}

/// KingReceiver 와 호환 가능한 메소드들을 사용할 수 있도록 하는 타입
/// Kingfisher 의 경우 `.kf` 를 사용하듯이 해당 모듈에서는 `.kr` 사용
/// 해당 protocol 의 extension 에서 구현됨
protocol KingReceiverCompatible: AnyObject {}

extension KingReceiverCompatible {
    var kr: KingReceiverWrapper<Self> {
        KingReceiverWrapper(self)
    }
}


