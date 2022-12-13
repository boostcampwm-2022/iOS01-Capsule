//
//  ThemeLabel.swift
//  SpaceCapsule
//
//  Created by 장재훈 on 2022/11/16.
//

import UIKit

class ThemeLabel: UILabel {
    convenience init(text: String? = nil, size: CGFloat, color: UIColor?) {
        self.init()
        
        self.text = text
        font = .themeFont(ofSize: size)
        textColor = color
    }
}

final class StatusLabel: ThemeLabel {
    func updateUserCapsuleStatus(nickname: String?, capsuleCounts: String?) {
        guard let nickname,
              let capsuleCounts else {
            return
        }
        
        let attrs1 = [NSAttributedString.Key.foregroundColor: UIColor.themeColor300]
        let attrs2 = [NSAttributedString.Key.foregroundColor: UIColor.themeGray300]
        
        let nicknameText = NSMutableAttributedString(string: nickname, attributes: attrs1 as [NSAttributedString.Key : Any])
        let explanationText = NSMutableAttributedString(string: "님이 생성한 공간캡슐 ", attributes: attrs2 as [NSAttributedString.Key : Any])
        let capsuleCount = NSMutableAttributedString(string: capsuleCounts, attributes: attrs1 as [NSAttributedString.Key : Any])
        let explanationText2 = NSMutableAttributedString(string: "개", attributes: attrs2 as [NSAttributedString.Key : Any])
        
        [explanationText, capsuleCount, explanationText2].forEach {
            nicknameText.append($0)
        }
        
        self.attributedText = nicknameText
    }
}
