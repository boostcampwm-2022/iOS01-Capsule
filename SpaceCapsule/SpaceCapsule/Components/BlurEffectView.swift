//
//  BlurEffectView.swift
//  SpaceCapsule
//
//  Created by jisu on 2022/12/08.
//

import UIKit

final class CapsuleBlurEffectView: UIVisualEffectView {
    init(width: CGFloat) {
        super.init(effect: UIBlurEffect(style: .systemUltraThinMaterialDark))
        self.layer.cornerRadius = width / 2
        self.clipsToBounds = true
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
