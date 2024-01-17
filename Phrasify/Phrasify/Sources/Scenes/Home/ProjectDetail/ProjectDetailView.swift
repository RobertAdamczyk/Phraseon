//
//  ProjectDetailView.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 21.12.23.
//

import SwiftUI

struct ProjectDetailView: View {

    @ObservedObject var viewModel: ProjectDetailViewModel
    @State private var scrollState: ScrollingAnimator.State = .scrollView

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 16) {
                Picker("", selection: $viewModel.selectedKeysOrder) {
                    ForEach(KeysOrder.allCases, id: \.self) { bar in
                        Text(bar.title)
                            .tag(bar)
                    }
                }
                .labelsHidden()
                .pickerStyle(.segmented)
                .padding(.bottom, 16)

                ForEach(viewModel.searchKeys, id: \.self) { key in
                    Button {
                        viewModel.onKeyTapped(key)
                    } label: {
                        KeyRow(key: key)
                    }

                }
            }
            .animate($scrollState)
            .padding(16)
        }
        .scrollSpace()
        .background(appColor(.black))
        .onAppear(perform: setupSegmentedControlAppearance)
        .searchable(text: $viewModel.searchText)
        .ignoresSafeArea(edges: .bottom)
        .overlay(alignment: .bottomTrailing, content: makeAddButton)
        .navigationTitle(viewModel.project.name)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: viewModel.onSettingsTapped, label: {
                    Image(systemName: "ellipsis")
                        .apply(.bold, size: .L, color: .paleOrange)
                        .rotationEffect(.degrees(90))
                })
            }
        }
    }

    @ViewBuilder
    private func makeAddButton() -> some View {
        Button(action: viewModel.onAddButtonTapped, label: {
            HStack(spacing: 4) {
                if scrollState == .scrollView {
                    Text("Add phrase")
                        .apply(.medium, size: .L, color: .black)
                }
                Text("X") // Placeholder
                    .apply(.medium, size: .L, color: .black)
                    .opacity(0)
                Image(systemName: "plus")
                    .apply(.semibold, size: .L, color: .black)
            }
            .padding(16)
            .background {
                UnevenRoundedRectangle(topLeadingRadius: 32, bottomLeadingRadius: 32)
                    .fill(appColor(.lightBlue))
            }
            .padding(.bottom, 32)
        })
        .opacity(viewModel.member?.hasPermissionToAddKey == true ? 1 : 0)
    }

    private func setupSegmentedControlAppearance() {
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(appColor(.paleOrange))
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor(appColor(.black))], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor(appColor(.paleOrange))], for: .normal)
    }
}

#Preview {
    ProjectDetailView(viewModel: .init(coordinator: MockCoordinator(), 
                                       project: .init(name: "",
                                                      technologies: [],
                                                      languages: [],
                                                      baseLanguage: .english,
                                                      members: [],
                                                      owner: "")))
}
