//
//  NottieListView.swift
//  Nottie
//
//  Created by jun on 4/15/25.
//

import SwiftUI

struct NottieListView: View {
    @State private var messagesByDate: [String: [String]] = [
        "4월 12일": ["안녕하세요!", "오늘 회의자료 다시 확인해 주세요.", "넵 확인했습니다. 감사합니다."],
        "4월 11일": ["이전 내용이 전달이 안 된 것 같아요. 다시 전달드립니다.", "좋은 하루 보내세요 :)", "리마인드 드립니다. 오늘 오후 3시까지 회신 부탁드립니다.", "네~"],
        "4월 10일": ["파일 첨부해드렸어요. 확인해주세요!", "확인 완료했습니다.", "조금 늦을 것 같습니다.", "ㄹㅇㄹㅇㄹㄴㅇㄹㄴㅇㄹㄴㄹㄴㅇ", "ㄹㄴㄹㄹㅇㄴㄹㄴㅇㄹㅇㄴㄹㄴㄹ", "ㄴㅇㄹㅇㄴㄹㄴㄹㅈㄷㄹㅈㄷㄹㅈㄷㄹㅈ", "ㅂㅂㄱㅈㄱㅂㅈㄱㅂㄱㅂㅈㄱㅈㄱㅈ"]
    ]
    
    
    private var sortedKeys : [String] {
        messagesByDate.keys.sorted(by: >)
    }
    
    var body: some View {
        NavigationStack{
            VStack{
                //노티 리스트
                List {
                    ForEach(sortedKeys, id: \.self) { date in
                        Section(header: Text(date).font(.headline)) {
                            ForEach(messagesByDate[date]!, id: \.self) { message in
                                HStack(alignment: .center) {
                                    //TODO: 항목 선택 버튼 (circle.dotted, circle.fill)
                                    Text(message)
                                }
                            }
                            .onDelete { offsets in
                                messagesByDate[date]?.remove(atOffsets: offsets)
                            }
                        }
                    }
                }
                .listStyle(.insetGrouped)
                
                //생성하기 버튼
                Button {
                    print("노티 생성 버튼 클릭됨")
                } label: {
                    Label {
                        Text("노티 생성하기")
                    } icon: {
                        Image(systemName: "pencil")
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(12)
                    .padding(.horizontal)
                }
            }
            .background(Color(UIColor.systemGroupedBackground))
            .navigationTitle(Text("노티"))
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button{
                        print("탭: 선택버튼")
                    } label: {
                        Text("선택")
                            .fontWeight(.semibold)
                    }
                }
            }
        }
    }
}

#Preview {
    NottieListView()
}
