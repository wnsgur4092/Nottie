//
//  NotificationHandler.swift
//  Nottie
//
//  Created by jun on 4/18/25.
//

import Foundation
import UserNotifications
import UIKit

class NotificationHandler: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate, NotificationServiceProtocol {
    
    // 앱 실행 시 알림 delegate 등록
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.delegate = self
//        requestAuthorization()
        return true
    }
    
    func requestAuthorization() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("🔴 알림 권한 요청 실패: \(error.localizedDescription)")
            } else {
                print(granted ? "✅ 알림 권한 허용됨" : "❌ 알림 권한 거부됨")
            }
        }
    }

    // 포그라운드 상태에서도 알림을 화면에 띄우도록 설정
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.banner, .list, .sound, .badge])
    }

    /// 즉시 또는 예약 알림 전송
    func sendNotification(
        id: UUID,
        date: Date,
        type: String,
        timeInterval: Double = 1,
        title: String,
        body: String
    ) {
        var trigger: UNNotificationTrigger?

        if type == "date" {
            let dateComponents = Calendar.current.dateComponents(
                [.day, .month, .year, .hour, .minute],
                from: date
            )
            trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        } else if type == "time" {
            trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        }

        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.default

        let request = UNNotificationRequest(
            identifier: id.uuidString,  // ✅ 고정된 ID로 예약
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request)
    }

    /// 예약된 알림 취소
    func cancelNotification(for id: UUID) {
        UNUserNotificationCenter.current()
            .removePendingNotificationRequests(withIdentifiers: [id.uuidString])
    }
}
