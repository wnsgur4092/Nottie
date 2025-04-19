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
                    title: "오늘 할 일 추가하기",
                    description: "그날그날 해야 할 일이나 떠오르는 생각을 간편하게 노티에 작성해보세요. 메모처럼 가볍게 기록하고 알림으로 받을 수 있어요.",
                    color: .green
                )
                onboardingBullet(
                    icon: "lock.square",
                    title: "잠금화면 알림으로 바로 확인",
                    description: "노티를 생성하면 바로 알림이 전송돼요. 잠금화면을 드래그 한 번만 하면 알림센터에서 손쉽게 확인할 수 있어요.",
                    color: .blue
                )
                onboardingBullet(
                    icon: "bell.badge",
                    title: "원하는 시간에 한 번 더 알림",
                    description: "중요한 노티는 원하는 시간에 한 번 더 알림을 받을 수 있어요. 하루 중 까먹기 쉬운 일을 놓치지 않도록 재알림으로 챙겨드려요.",
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
                    .foregroundColor(Color.primaryTextColor)
                    .background(Color.primaryColor)
                    .cornerRadius(12)
            }
            .padding(20)
            
        }
        .padding(.top, 40)
    }
    
    private func onboardingBullet(icon: String, title: String, description: String, color: Color) -> some View {
        HStack(alignment: .center, spacing: 20) {
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
