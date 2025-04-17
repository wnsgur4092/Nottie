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
    func save(content: String, isReminderOn: Bool, reminderTime: Date?){
        repository.save(content: content, isReminderOn: isReminderOn, reminderTime: reminderTime)
        load()
    }
    
    //MARK: 데이터 삭제하기
    func delete(nottie: Nottie){
        repository.delete(nottie)
        load()
    }
}
