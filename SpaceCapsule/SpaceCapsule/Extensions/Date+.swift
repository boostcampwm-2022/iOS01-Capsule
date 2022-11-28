//
//  Date+.swift
//  SpaceCapsule
//
//  Created by 장재훈 on 2022/11/23.
//

import Foundation

extension Date {
    static var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일"
        formatter.locale = Locale(identifier: "ko_KR")

        return formatter
    }

    static var dateTimeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일 HH:mm:ss"
        formatter.locale = Locale(identifier: "ko_KR")

        return formatter
    }

    var dateString: String {
        Date.dateFormatter.string(from: self)
    }

    var dateTimeString: String {
        Date.dateTimeFormatter.string(from: self)
    }

}
