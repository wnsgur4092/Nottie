//
//  NottieListView.swift
//  Nottie
//
//  Created by jun on 4/15/25.
//

import SwiftUI
import UserNotifications

struct NottieListView: View {
    @ObservedObject var viewModel: NottieListViewModel
    @State private var isPresentingCreationView = false
    @State private var isSelectionModeActive = false
    @State private var selectedNottieIDs: Set<UUID> = []
    @State private var isNotificationAuthorized: Bool = true
    @State private var showNotificationWarning: Bool = false
    @Environment(\.scenePhase) private var scenePhase
    
    private var nottieListSection: some View {
        let sections = viewModel.nottieSections

        return ScrollView {
            LazyVStack(alignment: .leading, spacing: 0) {
                ForEach(sections, id: \.date) { section in
                    Text(section.date)
                        .font(.headline)
                        .padding(.horizontal)
                        .padding(.top)

                    ForEach(section.notties, id: \.id) { nottie in
                        HStack(alignment: .center) {
                            if isSelectionModeActive {
                                let isSelected = selectedNottieIDs.contains(nottie.id)
                                Image(systemName: isSelected ? "circle.fill" : "circle.dotted")
                                    .foregroundStyle(isSelected ? Color.primaryColor : .primary)
                                    .padding(.trailing, 4)
                            }

                            Text(nottie.content)

                            Spacer()

                            if let reminderTime = nottie.reminderTime {
                                VStack(spacing: 4) {
                                    Image(systemName: "bell.fill")
                                        .foregroundStyle(Color.primaryColor)

                                    Text("\(reminderTime.formatted(date: .omitted, time: .shortened))")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                        .padding()
                        .background(Color(UIColor.secondarySystemGroupedBackground))
                        .cornerRadius(8)
                        .padding(.horizontal)
                        .padding(.vertical, 4)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            guard isSelectionModeActive else { return }
                            let generator = UIImpactFeedbackGenerator(style: .medium)
                            generator.impactOccurred()

                            withAnimation {
                                if selectedNottieIDs.contains(nottie.id) {
                                    selectedNottieIDs.remove(nottie.id)
                                } else {
                                    selectedNottieIDs.insert(nottie.id)
                                }
                            }
                        }
                    }
                }
            }
            .padding(.bottom, 8)
        }
        .background(Color(UIColor.systemGroupedBackground))
    }
    
    var body: some View {
        Group {
            if isNotificationAuthorized {
                VStack(spacing: 0) {
                    HStack(alignment: .center) {
                        Text("Nottie")
                            .font(.largeTitle.bold())
                        Spacer()
                        Button(isSelectionModeActive ? "취소" : "선택") {
                            withAnimation {
                                isSelectionModeActive.toggle()
                                selectedNottieIDs.removeAll()
                            }
                        }
                        .foregroundColor(Color.primaryColor)
                        .fontWeight(.bold)
                    }
                    .padding()
                    .background(Color(UIColor.systemGroupedBackground))

                    if showNotificationWarning {
                        HStack(spacing: 12) {
                            Image(systemName: "bell.slash")
                                .foregroundColor(.primaryTextColor)

                            VStack(alignment: .leading, spacing: 4) {
                                Text("알림 권한이 꺼져 있어요")
                                    .font(.headline)
                                    .foregroundColor(.primaryTextColor)
                                Text("설정에서 알림 권한을 허용해 주세요.")
                                    .font(.caption)
                                    .foregroundColor(.primaryTextColor)
                            }

                            Spacer()

                            Button("설정") {
                                if let url = URL(string: UIApplication.openSettingsURLString) {
                                    UIApplication.shared.open(url)
                                }
                            }
                            .fontWeight(.bold)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(Color.primaryColor)
                            .foregroundColor(.primaryTextColor)
                            .cornerRadius(8)
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.white.opacity(0.9))
                                .shadow(color: Color.black.opacity(0.15), radius: 4, x: 0, y: 1)
                        )
                        .padding(.horizontal)
                        .zIndex(1)
                    }

                    VStack {
                        if viewModel.nottieSections.isEmpty {
                            Spacer()
                            Text("아직 노티가 없어요")
                                .foregroundStyle(.secondary)
                            Spacer()
                        } else {
                            nottieListSection
                        }

                        if isSelectionModeActive {
                            Button {
                                let handler = NotificationHandler()
                                for id in selectedNottieIDs {
                                    if let nottie = viewModel.nottieSections.flatMap(\.notties).first(where: { $0.id == id }) {
                                        handler.sendNotification(id: nottie.id, date: Date(), trigger: .time, title: "🔔 재알림", body: nottie.content)
                                    }
                                }
                                selectedNottieIDs.removeAll()
                                isSelectionModeActive = false
                            } label: {
                                Label("노티 다시 보내기", systemImage: "arrow.up")
                                    .fontWeight(.bold)
                                    .foregroundColor(selectedNottieIDs.isEmpty ? Color.disabledTextColor : Color.primaryTextColor)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(selectedNottieIDs.isEmpty ? Color.disabledColor : Color.primaryColor)
                                    .cornerRadius(12)
                                    .padding(.horizontal)
                            }
                            .disabled(selectedNottieIDs.isEmpty)
                            .padding(.bottom)
                        } else {
                            Button {
                                isPresentingCreationView = true
                            } label: {
                                Label("노티 생성하기", systemImage: "pencil")
                                    .fontWeight(.black)
                                    .foregroundColor(Color.primaryTextColor)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.primaryColor)
                                    .cornerRadius(12)
                                    .padding(.horizontal)
                            }
                            .padding(.bottom)
                        }
                    }
                    .background(Color(UIColor.systemGroupedBackground))
                }
                .background(Color(UIColor.systemGroupedBackground))
                .sheet(isPresented: $isPresentingCreationView) {
                    NottieCreationView(viewModel: viewModel)
                }
            } else {
                VStack(spacing: 20) {
                    Spacer()
                    Image(systemName: "bell.slash")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 64, height: 64)
                        .foregroundColor(.secondary)
                    Text("알림 권한이 꺼져있어요")
                        .font(.headline)
                    Text("알림을 사용하려면 설정에서 권한을 허용해 주세요.")
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.secondary)
                    Button("설정으로 이동") {
                        if let url = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(url)
                        }
                    }
                    .padding()
                    .fontWeight(.bold)
                    .foregroundColor(.primaryTextColor)
                    .background(Color.primaryColor)
                    .cornerRadius(10)
                    Spacer()
                }
                .padding()
            }
        }
        .onAppear {
            UNUserNotificationCenter.current().getNotificationSettings { settings in
                DispatchQueue.main.async {
                    showNotificationWarning = settings.authorizationStatus != .authorized
                }
            }
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                UNUserNotificationCenter.current().getNotificationSettings { settings in
                    DispatchQueue.main.async {
                        showNotificationWarning = settings.authorizationStatus != .authorized
                    }
                }
            }
        }
    }
}

#Preview {
    let mockRepository = MockNottieRepository()
    let mockViewModel = NottieListViewModel(repository: mockRepository)
    NottieListView(viewModel: mockViewModel)
}
