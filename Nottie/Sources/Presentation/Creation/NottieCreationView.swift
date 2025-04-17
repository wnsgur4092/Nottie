//
//  NottieCreationView.swift
//  Nottie
//
//  Created by jun on 4/15/25.
//

import SwiftUI

struct NottieCreationView: View {
    @ObservedObject var viewModel: NottieListViewModel
    
    @State private var text = ""
    @State private var reminderTime = Date()
    @State private var isReminderOn = false
    
    @FocusState private var isTextEditorFocused: Bool
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ZStack {
                // 배경 탭 시 키보드 내리기
                Color.clear
                    .contentShape(Rectangle())
                    .onTapGesture {
                        isTextEditorFocused = false
                    }
                
                Form {
                    // TextEditor Section
                    Section {
                        VStack(alignment: .leading, spacing: 8) {
                            TextEditor(text: $text)
                                .frame(height: 120)
                                .focused($isTextEditorFocused)
                            
                            HStack {
                                Spacer()
                                Text("\(text.count)/100")
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    } header: {
                        Text("새로운 노티를 작성해보세요")
                    }
                    
                    // Reminder Section
                    Section {
                        Toggle("지정 시간으로 재알림", isOn: $isReminderOn)
                        
                        if isReminderOn {
                            DatePicker("", selection: $reminderTime, displayedComponents: .hourAndMinute)
                                .datePickerStyle(.wheel)
                        }
                    } header: {
                        Text("재알림이 필요하신가요?")
                    }
                }
            }
            .navigationTitle("노티 생성하기")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("취소") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("저장") {
                        viewModel.save(
                            content: text,
                            isReminderOn: isReminderOn,
                            reminderTime: isReminderOn ? reminderTime : nil
                        )
                        dismiss()
                    }
                }
            }
            .task {
                // 시트 열릴 때 자동으로 키보드 올리기
                isTextEditorFocused = true
            }
        }
    }
}
