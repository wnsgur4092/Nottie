//
//  NotificationHandler.swift
//  Nottie
//
//  Created by jun on 4/18/25.
//

import UserNotifications

class NotificationHandler: NSObject, UNUserNotificationCenterDelegate, NotificationServiceProtocol {
    static let shared = NotificationHandler()
    private let notificationCenter = UNUserNotificationCenter.current()

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.banner, .list, .sound, .badge])
    }

    //MARK: NotificationServiceProtocol 프로토콜 규격
    func requestAuthorization() {
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("🔴 알림 권한 요청 실패: \(error.localizedDescription)")
            } else {
                print(granted ? "✅ 알림 권한 허용됨" : "❌ 알림 권한 거부됨")
            }
        }
    }

    func sendNotification(
        id: UUID,
        date: Date,
        trigger: NotificationTriggerType,
        title: String,
        body: String,
        timeInterval: Double = 1
    ) {
        let triggerNotification: UNNotificationTrigger?

        switch trigger {
        case .date:
            triggerNotification = UNCalendarNotificationTrigger(dateMatching: createDateComponents(from: date), repeats: false)
        case .time:
            triggerNotification = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        }

        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.default

        let request = UNNotificationRequest(
            identifier: id.uuidString,
            content: content,
            trigger: triggerNotification
        )

        notificationCenter.add(request)
    }

    func cancelNotification(for id: UUID) {
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [id.uuidString])
    }

    private func createDateComponents(from date: Date) -> DateComponents {
        Calendar.current.dateComponents([.day, .month, .year, .hour, .minute], from: date)
    }
}
