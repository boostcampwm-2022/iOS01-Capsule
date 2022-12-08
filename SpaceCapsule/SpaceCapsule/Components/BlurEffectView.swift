//
//  BlurEffectView.swift
//  SpaceCapsule
//
//  Created by jisu on 2022/12/08.
//

import UIKit

final class CapsuleBlurEffectView: UIVisualEffectView {
    init() {
        super.init(effect: UIBlurEffect(style: .regular))
        // self.backgroundColor = .black.withAlphaComponent(0.2)
        self.layer.cornerRadius = FrameResource.listCapsuleCellWidth / 2
        self.clipsToBounds = true
        // self.alpha = FrameResource.blurEffectAlpha
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func changeStyle(to newStyle: UIBlurEffect.Style) {
        let effect = UIBlurEffect(style: newStyle)
        self.effect = effect
    }
}
