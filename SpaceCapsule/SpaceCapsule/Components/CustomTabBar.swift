//
//  CustomTabBar.swift
//  SpaceCapsule
//
//  Created by 장재훈 on 2022/11/17.
//

import UIKit

extension UITabBar {
    
}

class CustomTabBar: UITabBar {
    lazy var centerButton: UIButton = {
        let button = UIButton()
        button.frame.size = CGSize(
            width: FrameResource.addCapsuleButtonSize,
            height: FrameResource.addCapsuleButtonSize
        )

        button.setImage(.addCapsuleFill, for: .normal)
        button.backgroundColor = .themeColor200
        button.tintColor = .white
        button.layer.cornerRadius = FrameResource.addCapsuleButtonSize / 2

        self.addSubview(button)

        return button
    }()
    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//
//        backgroundColor = .white
//        print("Hello")
//    }
//
//    @available(*, unavailable)
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        centerButton.center = CGPoint(x: frame.width / 2, y: -5)
    }

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard !clipsToBounds && !isHidden && alpha > 0 else { return nil }

        return centerButton.frame.contains(point) ? centerButton : super.hitTest(point, with: event)
    }
}
