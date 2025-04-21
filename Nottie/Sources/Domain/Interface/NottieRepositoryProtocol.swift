//
//  NottieRepositoryProtocol.swift
//  Nottie
//
//  Created by jun on 4/16/25.
//

import Foundation

protocol NottieRepositoryProtocol {
    func fetchNotties() -> [Nottie]
    func saveNottie(content: String, isReminderOn: Bool, reminderTime: Date?) -> Nottie
    func deleteNottie(_ nottie: Nottie)
}
