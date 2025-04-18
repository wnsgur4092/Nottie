//
//  NottieListViewModel.swift
//  Nottie
//
//  Created by jun on 4/16/25.
//

import Foundation

final class NottieListViewModel: ObservableObject{
    @Published var nottieSections: [(date: String, notties: [Nottie])] = []
    
    private let repository: NottieRepositoryProtocol
    
    init(repository: NottieRepositoryProtocol){
        self.repository = repository
        load()
    }
    
    //MARK: 데이터 불러오기
    func load() {
        let all = repository.fetchAll()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        let grouped = Dictionary(grouping: all, by: { formatter.string(from: $0.createdAt) })
        
        nottieSections = grouped
            .sorted { $0.key > $1.key }
            .map { (date: $0.key, notties: $0.value) }
    }
    
    //MARK: 데이터 저장하기
    func saveWithNotification(content: String, isReminderOn: Bool, reminderTime: Date?) {
        let newNottie: Nottie = repository.save(content: content, isReminderOn: isReminderOn, reminderTime: reminderTime)
        let handler = NotificationHandler()

        // ✅ 즉시 알림은 고유 UUID로 발송 (삭제와 무관하게 발송)
        handler.sendNotification(
            id: UUID(),
            date: Date(),
            type: "time",
            title: "새로운 노티!",
            body: content
        )

        // ✅ 지정 알림은 nottie.id를 ID로 사용 (삭제 시 취소 가능)
        if isReminderOn, let reminderTime = reminderTime {
            handler.sendNotification(
                id: newNottie.id,
                date: reminderTime,
                type: "date",
                title: "노티 리마인더!!",
                body: content
            )
        }

        load()
    }
    //MARK: 데이터 삭제하기
    func delete(nottie: Nottie) {
        let handler = NotificationHandler()
        handler.cancelNotification(for: nottie.id)
        
        repository.delete(nottie)

        nottieSections = nottieSections.compactMap { section in
            let filtered = section.notties.filter { $0.id != nottie.id }
            return filtered.isEmpty ? nil : (date: section.date, notties: filtered)
        }
    }
}
