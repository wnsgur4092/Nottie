//
//  NottieRepositoryProtocol.swift
//  Nottie
//
//  Created by jun on 4/16/25.
//

import Foundation

protocol NottieRepositoryProtocol {
    func fetchAll() -> [Nottie]
    func save(content: String, isReminderOn: Bool, reminderTime: Date?)
    func delete(_ nottie: Nottie)
}
