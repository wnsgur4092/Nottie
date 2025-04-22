//
//  NottieRepository.swift
//  Nottie
//
//  Created by jun on 4/16/25.
//

import Foundation
import SwiftData

final class NottieRepository: NottieRepositoryProtocol {
    private let context: ModelContext
    
    init(context: ModelContext){
        self.context = context
    }
    
    private func saveContext() {
        do {
            try context.save()
        } catch {
            print("🔴 저장 실패: \(error.localizedDescription)")
        }
    }
    
    func saveNottie(content: String, isReminderOn: Bool, reminderTime: Date?) -> Nottie {
        let newNottie = Nottie(content: content, isReminderOn: isReminderOn, reminderTime: reminderTime)
        context.insert(newNottie)
        saveContext()
        return newNottie
    }

    func fetchNotties() -> [Nottie] {
        let descriptor = FetchDescriptor<Nottie>(sortBy: [SortDescriptor(\.createdAt, order: .reverse)])
        return (try? context.fetch(descriptor)) ?? []
    }
    
    func deleteNottie(_ nottie: Nottie) {
        context.delete(nottie)
        saveContext()
    }
}
