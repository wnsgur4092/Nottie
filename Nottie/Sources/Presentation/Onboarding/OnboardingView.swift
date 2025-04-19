//
//  OnboardingView.swift
//  Nottie
//
//  Created by jun on 4/19/25.
//

import SwiftUI

struct OnboardingView: View {
    @StateObject var viewModel = OnboardingViewModel(notificationService: NotificationHandler())
    @AppStorage("hasSeenOnboarding") var hasSeenOnboarding: Bool = false
    @State private var isShowingListView = false
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack(spacing: 40){
            Text("Nottie 시작하기")
                .font(.largeTitle.bold())
                .multilineTextAlignment(.center)
            
            
            VStack(alignment: .leading, spacing: 40) {
                onboardingBullet(
                    icon: "note.text.badge.plus",
                    title: "즉시 알림 받기",
                    description: "노티를 생성하면 바로 알림이 전송돼요. 나중에 알림센터에서 쉽게 확인할 수 있어요.",
                    color: .green
                )
                onboardingBullet(
                    icon: "lock.square",
                    title: "잠금화면에서 노티 확인",
                    description: "화면을 켜고 드래그 한 번으로 알림센터에서 노티를 빠르게 확인할 수 있어요.",
                    color: .blue
                )
                onboardingBullet(
                    icon: "bell.badge",
                    title: "중요한 노티는 재알림",
                    description: "중요한 내용은 원하는 시간에 한 번 더 알림으로 받아볼 수 있어요.",
                    color: .yellow
                )
            }
            .padding(.horizontal, 40)
            
            Spacer()
            
            Button {
                viewModel.requestNotificationPermission()
                hasSeenOnboarding = true
                isPresented = false
            } label: {
                Text("계속")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.yellow)
                    .cornerRadius(12)
            }
            .padding(20)
            
        }
        .padding(.top, 40)
    }
    
    private func onboardingBullet(icon: String, title: String, description: String, color: Color) -> some View {
        HStack(alignment: .center, spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(color)
                .font(.system(size: 33))
            VStack(alignment: .leading, spacing: 4) {
                Text(title).fontWeight(.medium)
                Text(description).font(.footnote).foregroundColor(.secondary)
            }
        }
    }
}

#Preview {
    OnboardingView(isPresented: .constant(true))
}
