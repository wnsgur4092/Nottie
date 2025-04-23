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
                Form {
                    // TextEditor Section
                    Section {
                        VStack(alignment: .leading, spacing: 8) {
                            TextEditor(text: $text)
                                .frame(height: 120)
                                .focused($isTextEditorFocused)
                                .onChange(of: text) { newValue in
                                    let font = UIFont.preferredFont(forTextStyle: .body)
                                    let textView = UITextView()
                                    textView.font = font
                                    textView.text = newValue

                                    let lineHeight = font.lineHeight
                                    let fittingSize = CGSize(width: UIScreen.main.bounds.width - 40, height: .greatestFiniteMagnitude)
                                    let size = textView.sizeThatFits(fittingSize)
                                    let numberOfLines = Int(size.height / lineHeight)

                                    if numberOfLines > 4 || newValue.count > 80 {
                                        text = String(newValue.prefix(80))
                                    }
                                }
                            
                            HStack {
                                Spacer()
                                Text("\(text.count)/80")
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
                .simultaneousGesture(
                    TapGesture().onEnded {
                        isTextEditorFocused = false
                    }
                )
            }
            .navigationTitle("노티 생성하기")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("취소") {
                        dismiss()
                    }
                    .foregroundColor(.primaryColor)
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("저장") {
                        viewModel.saveWithNotification(
                            content: text,
                            isReminderOn: isReminderOn,
                            reminderTime: isReminderOn ? reminderTime : nil
                        )
                        dismiss()
                    }
                    .foregroundColor(.primaryColor)
                }
            }
            .task {
                isTextEditorFocused = true
            }
        }
    }
}
