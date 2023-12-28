//
//  ProjectDetailView.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 21.12.23.
//

import SwiftUI

// TODO: Move
enum ProjectDetailBar: String, CaseIterable {
    case alphabetically
    case recent
    case alert

    var title: String {
        switch self {
        case .alphabetically: return "A-Z"
        case .recent: return "Recent"
        case .alert: return "Alert"
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
                ForEach(viewModel.keys, id: \.self) { key in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(key.id ?? "")
                            .apply(.medium, size: .M, color: .white)
                        HStack(spacing: 4) {
                            Image(systemName: "clock")
                            Text(key.lastUpdatedAt.timeAgo)
                        }
                        .apply(.medium, size: .S, color: .lightGray)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(8)
                    .background {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(appColor(.darkGray))
                    }
                    .padding(.vertical, 4)
                }
                .animate($scrollState)
            }
            .scrollSpace()
            .scrollIndicators(.hidden)
        }
        .padding(16)
        .background(appColor(.black))
        .onAppear(perform: setupSegmentedControlAppearance)
        .searchable(text: $viewModel.searchText)
        .ignoresSafeArea(edges: .bottom)
        .overlay(alignment: .bottomTrailing, content: makeAddButton)
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
    ProjectDetailView(viewModel: .init(coordinator: MockCoordinator(), 
                                       project: .init(name: "",
                                                      technologies: [],
                                                      languages: [],
                                                      baseLanguage: .english,
                                                      members: [],
                                                      owner: "")))
}
