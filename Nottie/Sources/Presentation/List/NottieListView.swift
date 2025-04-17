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
    
    var body: some View {
        NavigationStack{
            VStack{
                //노티 리스트
                List {
                    ForEach(viewModel.nottieSections, id: \.date) { section in
                        Section(header: Text(section.date)) {
                            ForEach(section.notties, id: \.id) { nottie in
                                Text(nottie.content)
                            }
                            .onDelete { offsets in
                                let items = section.notties
                                offsets.forEach { idx in
                                    viewModel.delete(nottie: items[idx])
                                }
                            }
                        }
                    }
                }
                .listStyle(.insetGrouped)
                
                //생성하기 버튼
                Button {
                    print("탭: 노티 생성 버튼 클릭됨")
                    isPresentingCreationView = true
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
            .sheet(isPresented: $isPresentingCreationView){
                NottieCreationView()
            }
        }
    }
}

#Preview {
    NottieListView(viewModel: NottieListViewModel(repository: MockNottieRepository()))
}
