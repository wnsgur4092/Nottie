//
//  OnboardingViewModel.swift
//  Nottie
//
//  Created by jun on 4/19/25.
//

import Foundation

final class OnboardingViewModel: ObservableObject {
    private let notificationService: NotificationServiceProtocol

    init(notificationService: NotificationServiceProtocol) {
        self.notificationService = notificationService
    }

    func requestNotificationPermission() {
        notificationService.requestAuthorization()
    }
}
