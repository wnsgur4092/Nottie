//
//  NottieListView.swift
//  Nottie
//
//  Created by jun on 4/15/25.
//

import SwiftUI

import SwiftUI

struct NottieListView: View {
    @StateObject var viewModel: NottieListViewModel
    @State private var isPresentingCreationView = false
    
    var body: some View {
        NavigationStack {
            VStack {
                if viewModel.nottieSections.isEmpty {
                    // 비어있는 경우 Placeholder
                    Spacer()
                    Text("아직 노티가 없어요")
                        .foregroundStyle(.secondary)
                    Spacer()
                } else {
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
                    .background(Color(UIColor.systemGroupedBackground))
                }
                
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
            .background(Color(UIColor.systemGroupedBackground))
            .navigationTitle("노티")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("선택") {
                        print("탭: 선택버튼")
                    }
                    .fontWeight(.semibold)
                }
            }
            .sheet(isPresented: $isPresentingCreationView) {
                NottieCreationView()
            }
        }
    }
}

#Preview {
    NottieListView(viewModel: NottieListViewModel(repository: MockNottieRepository()))
}
