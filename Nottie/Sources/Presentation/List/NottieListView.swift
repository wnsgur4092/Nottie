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
        NavigationView {
            VStack {
                if viewModel.nottieSections.isEmpty {
                    Spacer()
                    Text("아직 노티가 없어요")
                        .foregroundStyle(.secondary)
                    Spacer()
                } else {
                    let sections = viewModel.nottieSections

                    List {
                        ForEach(0..<sections.count, id: \.self) { sectionIndex in
                            let section = sections[sectionIndex]

                            Section(header: Text(section.date)) {
                                ForEach(0..<section.notties.count, id: \.self) { rowIndex in
                                    let nottie = section.notties[rowIndex]
                                    Text(nottie.content)
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
