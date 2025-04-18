//
//  NotificationHandler.swift
//  Nottie
//
//  Created by jun on 4/18/25.
//

import Foundation
import UserNotifications
import UIKit

class NotificationHandler: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    // 앱 실행 시 알림 delegate 등록
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.delegate = self
        return true
    }

    // 포그라운드 상태에서도 알림을 화면에 띄우도록 설정
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.banner, .list, .sound, .badge])
    }

    // 즉시 or 예약 알림 전송 (time 또는 date 기반)
    func sendNotification(date: Date, type: String, timeInterval: Double = 1, title: String, body: String) {
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
            identifier: UUID().uuidString,
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request)
    }
}
