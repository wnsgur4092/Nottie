//
//  Nottie.swift
//  Nottie
//
//  Created by jun on 4/16/25.
//

import Foundation
import SwiftData

@Model
final class Nottie {
    var id: UUID
    var content: String
    var createdAt: Date
    var isReminderOn: Bool
    var reminderTime: Date?

    init(content: String, isReminderOn: Bool = false, reminderTime: Date? = nil, createdAt: Date = .now) {
        self.id = UUID()
        self.content = content
        self.isReminderOn = isReminderOn
        self.reminderTime = reminderTime
        self.createdAt = createdAt
    }
}
