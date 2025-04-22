//
//  NotificationServiceProtocol.swift
//  Nottie
//
//  Created by jun on 4/19/25.
//

import Foundation

enum NotificationTriggerType {
    case date
    case time
}

protocol NotificationServiceProtocol {
    func requestAuthorization()
    func sendNotification(
        id: UUID,
        date: Date,
        trigger: NotificationTriggerType,
        title: String,
        body: String,
        timeInterval: Double
    )
    func cancelNotification(for id: UUID)
}
