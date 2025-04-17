//
//  MockNottieRepository.swift
//  Nottie
//
//  Created by jun on 4/16/25.
//

import Foundation

final class MockNottieRepository: NottieRepositoryProtocol {
    private(set) var notties: [Nottie] = [
        Nottie(content: "🍎 모의 메시지", createdAt: .now),
        Nottie(content: "🍌 테스트 메시지", createdAt: .now.addingTimeInterval(-3600))
    ]
    
    func fetchAll() -> [Nottie] {
        return notties
    }

    func save(content: String, isReminderOn: Bool, reminderTime: Date?) {
        let new = Nottie(content: content, isReminderOn: isReminderOn, reminderTime: reminderTime)
        notties.append(new)
    }

    func delete(_ nottie: Nottie) {
        notties.removeAll { $0.id == nottie.id }
    }
}
