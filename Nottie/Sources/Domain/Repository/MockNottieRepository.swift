//
//  MockNottieRepository.swift
//  Nottie
//
//  Created by jun on 4/16/25.
//

import Foundation

final class MockNottieRepository: NottieRepositoryProtocol  {
    var saved: [Nottie] = []
    var deleted: [Nottie] = []
    
    func fetchAll() -> [Nottie] {
        return [
            Nottie(content: "Mock 메시지 1", createdAt: .now),
            Nottie(content: "Mock 메시지 2", createdAt: .now.addingTimeInterval(-3600))
        ]
    }
    
    func save(content: String, isReminderOn: Bool, reminderTime: Date?) {
        let mockData = Nottie(content: content, isReminderOn: isReminderOn , reminderTime: reminderTime)
        saved.append(mockData)
        
    }
    
    func delete(_ nottie: Nottie) {
        deleted.append(nottie)
    }
    
    
}
