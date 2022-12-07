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

    func sendNotification(seconds: Double) {
        let notificationContent = UNMutableNotificationContent()

        notificationContent.title = "알림 테스트"
        notificationContent.body = "이것은 알림을 테스트 하는 것이다"

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: seconds, repeats: false)
        let request = UNNotificationRequest(identifier: "testNotification",
                                            content: notificationContent,
                                            trigger: trigger)

        userNotificationCenter.add(request) { error in
            if let error = error {
                print("Notification Error: ", error)
            }
        }
    }
}
