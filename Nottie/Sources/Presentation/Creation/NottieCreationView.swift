//
//  NottieCreationView.swift
//  Nottie
//
//  Created by jun on 4/15/25.
//

import SwiftUI

struct NottieCreationView: View {
    @State private var isReminderOn = false
    @FocusState private var isTextEditorFocused: Bool
    
    var body: some View {
        Form{
            //TextEditor
            Section {
                VStack{
                    TextEditor(text: .constant(""))
                        .frame(height: 120)
                        .focused($isTextEditorFocused)
                    
                    HStack{
                        Spacer()
                        Text("0/100자")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                }
  
            } header: {
                Text("새로운 노티를 작성해보세요")
            }
            
            //Re-notification Toggle
            Section {
                Toggle("지정 시간으로 재알림", isOn: $isReminderOn)
                
                DatePicker("", selection: .constant(Date()), displayedComponents: .hourAndMinute)
                    .datePickerStyle(.wheel)
            } header: {
                Text("재알림이 필요하신가요?")
            }

            
            .navigationTitle("노티 생성하기")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        //TODO: 취소버튼 로직 추가
                        print("탭: 취소버튼")
                    } label: {
                        Text("취소")
                    }
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        //TODO: 저장버튼 로직 추가
                        print("탭: 저장버튼")
                    } label: {
                        Text("저장")
                    }

                }
            }
        }
    }
}

#Preview {
    NottieCreationView()
}
