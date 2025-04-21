//
//  NotificationServiceProtocol.swift
//  Nottie
//
//  Created by jun on 4/19/25.
//

import Foundation

protocol NotificationServiceProtocol {
    func requestAuthorization()
    func sendNotification(id: UUID, date: Date, type: String, timeInterval: Double, title: String, body: String)
    func cancelNotification(for id: UUID)
}
