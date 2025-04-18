//
//  NottieListView.swift
//  Nottie
//
//  Created by jun on 4/15/25.
//

import SwiftUI

struct NottieListView: View {
    @StateObject var viewModel: NottieListViewModel
    @State private var isPresentingCreationView = false
    @State private var isSelectionModeActive = false
    @State private var selectedNottieIDs: Set<UUID> = []

    private var nottieListSection: some View {
        let sections = viewModel.nottieSections

        return List {
            ForEach(0..<sections.count, id: \.self) { sectionIndex in
                let section = sections[sectionIndex]

                Section(header: Text(section.date)) {
                    ForEach(0..<section.notties.count, id: \.self) { rowIndex in
                        let nottie = section.notties[rowIndex]
                        HStack {
                            if isSelectionModeActive {
                                let isSelected = selectedNottieIDs.contains(nottie.id)
                                Image(systemName: isSelected ? "circle.fill" : "circle.dotted")
                                    .foregroundStyle(isSelected ? .orange : .primary)
                                    .transition(.move(edge: .leading).combined(with: .opacity))
                                    .animation(.easeInOut(duration: 0.25), value: isSelectionModeActive)
                            }

                            Text(nottie.content)
                            Spacer()

                            if nottie.reminderTime != nil {
                                Image(systemName: "bell.fill")
                                    .foregroundStyle(.yellow)
                            }
                        }
                        .contentShape(Rectangle()) // 전체 HStack 클릭 가능하게
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
                    .onDelete { offsets in
                        offsets.forEach { idx in
                            let nottie = section.notties[idx]
                            viewModel.delete(nottie: nottie)
                        }
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
        .background(Color(UIColor.systemGroupedBackground))
    }

    var body: some View {
        NavigationView {
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
                                handler.sendNotification(date: Date(), type: "time", title: "🔔 재알림", body: nottie.content)
                            }
                        }
                        selectedNottieIDs.removeAll()
                        isSelectionModeActive = false
                    } label: {
                        Label("노티 재알림", systemImage: "arrow.up")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.orange)
                            .cornerRadius(12)
                            .padding(.horizontal)
                    }
                    .padding(.bottom)
                } else {
                    Button {
                        isPresentingCreationView = true
                    } label: {
                        Label("노티 생성하기", systemImage: "pencil")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(12)
                            .padding(.horizontal)
                    }
                    .padding(.bottom)
                }
            }
            .background(Color(UIColor.systemGroupedBackground))
            .navigationTitle("노티")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(isSelectionModeActive ? "취소" : "선택") {
                        withAnimation {
                            isSelectionModeActive.toggle()
                            selectedNottieIDs.removeAll()
                        }
                    }
                    .fontWeight(.semibold)
                }
            }
            .sheet(isPresented: $isPresentingCreationView) {
                NottieCreationView(viewModel: viewModel)
            }
        }
    }
}

#Preview {
    let mockRepository = MockNottieRepository()
    let mockViewModel = NottieListViewModel(repository: mockRepository)
    NottieListView(viewModel: mockViewModel)
}
