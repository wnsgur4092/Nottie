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
        Nottie(content: "🍌 테스트 메시지", createdAt: .now.addingTimeInterval(-3600)),
        
        Nottie(content: "🍊 지난주 메시지", createdAt: Calendar.current.date(byAdding: .day, value: -7, to: .now)!),
        Nottie(content: "🍇 어제 메시지", createdAt: Calendar.current.date(byAdding: .day, value: -1, to: .now)!),
        Nottie(content: "🍉 이틀 전 메시지", createdAt: Calendar.current.date(byAdding: .day, value: -2, to: .now)!),
        Nottie(content: "🍓 3일 전 메시지", createdAt: Calendar.current.date(byAdding: .day, value: -3, to: .now)!),
        Nottie(content: "🍒 5일 전 메시지", createdAt: Calendar.current.date(byAdding: .day, value: -5, to: .now)!),
        Nottie(content: "🥝 10일 전 메시지", createdAt: Calendar.current.date(byAdding: .day, value: -10, to: .now)!),
        Nottie(content: "🥥 30일 전 메시지", createdAt: Calendar.current.date(byAdding: .day, value: -30, to: .now)!)
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
