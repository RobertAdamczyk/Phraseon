//
//  ProjectDetailView.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 21.12.23.
//

import SwiftUI

// TODO: Move
enum ProjectDetailBar: String, CaseIterable {
    case all
    case recent
    case lastAdded

    var title: String {
        switch self {
        case .all: return "All"
        case .recent: return "Recent"
        case .lastAdded: return "Last added"
        }
    }
}

struct ProjectDetailView: View {

    @ObservedObject var viewModel: ProjectDetailViewModel
    @State private var scrollState: ScrollingAnimator.State = .scrollView

    var body: some View {
        VStack(alignment: .leading, spacing: 32) {
            AppTitle(title: viewModel.project.name)
            Picker("", selection: $viewModel.selectedBar) {
                ForEach(ProjectDetailBar.allCases, id: \.self) { bar in
                    Text(bar.title)
                        .tag(bar)
                }
            }
            .labelsHidden()
            .pickerStyle(.segmented)

            ScrollView {
                Text("key_key_key")
                .animate($scrollState)
            }
            .scrollSpace()
        }
        .padding(16)
        .background(appColor(.black))
        .overlay(alignment: .bottomTrailing, content: makeAddButton)
        .onAppear(perform: setupSegmentedControlAppearance)
        .searchable(text: $viewModel.searchText)
    }

    @ViewBuilder
    private func makeAddButton() -> some View {
        Button(action: viewModel.onAddButtonTapped, label: {
            HStack(spacing: 4) {
                if scrollState == .scrollView {
                    Text("Add phrase")
                        .apply(.medium, size: .L, color: .black)
                }
                Text("X")
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
    }

    private func setupSegmentedControlAppearance() {
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(appColor(.paleOrange))
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor(appColor(.black))], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor(appColor(.paleOrange))], for: .normal)
    }
}

#Preview {
    ProjectDetailView(viewModel: .init(coordinator: MockCoordinator(), project: .init(name: "", technologies: [],
                                                                                      languages: [], members: [], owner: "")))
}
