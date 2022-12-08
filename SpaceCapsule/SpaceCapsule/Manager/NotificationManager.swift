//
//  NotificationManager.swift
//  SpaceCapsule
//
//  Created by young june Park on 2022/12/07.
//

import Foundation
import UserNotifications

final class NotificationManager {
    static let shared = NotificationManager()
    let userNotificationCenter = UNUserNotificationCenter.current()

    private init() {}

    func requestNotificationAuthorization() {
        userNotificationCenter.requestAuthorization(options: [.alert, .sound, .badge], completionHandler: { didAllow, error in
            if let error = error {
                print(error.localizedDescription)
            }
            if didAllow {
                print("Push: 권한 허용")
            } else {
                print("Push: 권한 거부")
            }
        })
    }

    func checkNotificationAuthorization(completion: @escaping ((Bool) -> Void)) {
        NotificationManager.shared.userNotificationCenter.getNotificationSettings { setting in
            switch setting.authorizationStatus {
            case .authorized:
                completion(true)
            default:
                completion(false)
                return
            }
        }
    }
}
