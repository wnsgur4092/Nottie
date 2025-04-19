//
//  NottieListView.swift
//  Nottie
//
//  Created by jun on 4/15/25.
//

import SwiftUI

struct NottieListView: View {
    @ObservedObject var viewModel: NottieListViewModel
    @State private var isPresentingCreationView = false
    @State private var isSelectionModeActive = false
    @State private var selectedNottieIDs: Set<UUID> = []
    
    private var nottieListSection: some View {
        let sections = viewModel.nottieSections
        
        return List {
            ForEach(sections, id: \.date) { section in
                Section(header: Text(section.date)) {
                    ForEach(section.notties, id: \.id) { nottie in
                        HStack(alignment: .center) {
                            if isSelectionModeActive {
                                let isSelected = selectedNottieIDs.contains(nottie.id)
                                Image(systemName: isSelected ? "circle.fill" : "circle.dotted")
                                    .foregroundStyle(isSelected ? Color("primaryColor") : .primary)
                                    .opacity(isSelectionModeActive ? 1 : 0)
                                    .animation(.easeInOut(duration: 0.2), value: isSelectionModeActive)
                            }
                            
                            Text(nottie.content)
                                
                            Spacer()
                            
                            VStack(spacing: 4){
                                if nottie.reminderTime != nil
                                {
                                    Image(systemName: "bell.fill")
                                        .foregroundStyle(Color("primaryColor"))
                                    
                                    VStack{
                                        Text("\(nottie.reminderTime!.formatted(date: .omitted, time: .shortened))")
                                    }
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                }
                            }
                        }
                        .padding(.vertical, 8)
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
                    .onDelete(perform: { offsets in
                        withAnimation {
                            for offset in offsets {
                                let nottie = section.notties[offset]
                                viewModel.delete(nottie: nottie)
                            }
                        }
                    })
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
                                handler.sendNotification(id: nottie.id, date: Date(), type: "time", title: "🔔 재알림", body: nottie.content)
                            }
                        }
                        selectedNottieIDs.removeAll()
                        isSelectionModeActive = false
                    } label: {
                        Label("노티 다시 보내기", systemImage: "arrow.up")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(selectedNottieIDs.isEmpty ? Color("disabledColor") : Color("primaryColor"))
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
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color("primaryColor"))
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
                    .foregroundColor(Color("primaryColor"))
                    .fontWeight(.bold)
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
