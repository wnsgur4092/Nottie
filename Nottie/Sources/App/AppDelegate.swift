////
////  AppDelegate.swift
////  Nottie
////
////  Created by jun on 4/18/25.
////
//
//import UIKit
//import UserNotifications
//
//class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
//    func application(_ application: UIApplication,
//                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
//        NotificationManager.shared.configureDelegate()
//        NotificationManager.shared.requestAuthorization()
//        return true
//    }
//    
//    func userNotificationCenter(_ center: UNUserNotificationCenter,
//                                willPresent notification: UNNotification,
//                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//        completionHandler([.banner, .list, .sound, .badge])
//    }
//}
