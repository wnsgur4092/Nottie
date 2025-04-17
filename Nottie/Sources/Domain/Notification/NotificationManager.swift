//
//  NotificationManager.swift
//  Nottie
//
//  Created by jun on 4/18/25.
//

import Foundation
import UserNotifications

final class NotificationManager{
    static let shared = NotificationManager()
    
    private init(){}
    
    func requestAutorization(){
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if let error = error {
                print("❌ 알림 권한 요청 실패: \(error.localizedDescription)")
            } else {
                print(granted ? "✅ 알림 권한 허용" : "⚠️알림 권한 거부")
            }
        }
    }
    
    func sendImmediateNotification(title: String, body: String){
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        
        let request = UNNotificationRequest(
            identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request){ error in
            if let error = error {
                print("❌ 알림 등록 실패: \(error.localizedDescription)")
            } else {
                print("✅ 알림 등록 성공")
            }
        }
    }
}
