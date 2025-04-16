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
    

    func fetchAll() -> [Nottie] {
        let descriptor = FetchDescriptor<Nottie>(sortBy: [SortDescriptor(\.createdAt, order: .reverse)])
        return (try? context.fetch(descriptor)) ?? []
    }
    
    func save(content: String, isReminderOn: Bool, reminderTime: Date?) {
        let newNottie = Nottie(content: content, isReminderOn: isReminderOn, reminderTime: reminderTime)
        context.insert(newNottie)
        try? context.save()
    }
    
    func delete(_ nottie: Nottie) {
        context.delete(nottie)
        try? context.save()
    }
    
    
}
