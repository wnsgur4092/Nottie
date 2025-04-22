//
//  AppDelegate.swift
//  Nottie
//
//  Created by jun on 4/21/25.
//

import Foundation
import UIKit
import UserNotifications


class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        UNUserNotificationCenter.current().delegate = NotificationHandler.shared
        return true
    }
}
