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
            Form {
                // TextEditor Section
                Section {
                    //TODO: Placeholder 생성하기
                    VStack(alignment: .leading, spacing: 8) {
                        TextEditor(text: $text)
                            .frame(height: 120)
                            .focused($isTextEditorFocused)
                        
                        //TODO: 글자 수 카운팅 로직 작성
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
                        //TODO: 저장 버튼 로직 작성
                        viewModel.save(content: text, isReminderOn: isReminderOn, reminderTime: isReminderOn ? reminderTime : nil)
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    NottieCreationView(viewModel: NottieListViewModel(repository: MockNottieRepository()))
}
