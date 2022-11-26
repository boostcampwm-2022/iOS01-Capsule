//
//  UILabel+.swift
//  SpaceCapsule
//
//  Created by 장재훈 on 2022/11/26.
//

import UIKit

extension UILabel {
    func asFontColor(targetStringList: [String], size: CGFloat, color: UIColor?) {
        let fullText = text ?? ""
        let attributedString = NSMutableAttributedString(string: fullText)

        targetStringList.forEach {
            let range = (fullText as NSString).range(of: $0)
            attributedString.addAttributes(
                [.font: UIFont.themeFont(ofSize: size), .foregroundColor: color],
                range: range
            )
        }
        
        attributedText = attributedString
    }
}
