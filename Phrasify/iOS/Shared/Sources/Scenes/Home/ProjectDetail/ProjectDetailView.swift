//
//  ProjectDetailView.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 21.12.23.
//

import SwiftUI
import Model

struct ProjectDetailView: View {

    @ObservedObject var viewModel: ProjectDetailViewModel

    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(alignment: .leading, spacing: 16) {
                if viewModel.shouldShowPicker {
                    Picker("", selection: $viewModel.selectedKeysOrder) {
                        ForEach(KeysOrder.allCases, id: \.self) { bar in
                            Text(bar.title)
                                .tag(bar)
                        }
                    }
                    .labelsHidden()
                    .pickerStyle(.segmented)
                    .padding(.bottom, 16)
                }

                switch viewModel.state {
                case .loaded(let keys):
                    ForEach(keys, id: \.self) { key in
                        Button {
                            viewModel.onKeyTapped(key)
                        } label: {
                            KeyRow(key: key, shouldShowReviewStatus: viewModel.shouldShowReviewStatus)
                        }
                        .onAppear {
                            viewModel.onKeyAppear(key)
                        }
                    }
                case .searched(let keys):
                    ForEach(keys, id: \.self.objectID) { key in
                        Button {
                            viewModel.onAlgoliaKeyTapped(key)
                        } label: {
                            AlgoliaKeyRow(key: key, shouldShowReviewStatus: viewModel.shouldShowReviewStatus)
                        }
                    }
                default: EmptyView()
                }
            }
            .scrollTargetLayout()
            .padding(16)
        }
        .onAppear(perform: setupSegmentedControlAppearance)
        .opacity(viewModel.shouldShowContent ? 1 : 0)
        .overlay(content: makeNotFoundViewIfNeeded)
        .searchable(text: $viewModel.searchText, isPresented: $viewModel.isSearchPresented)
        .overlay(content: makeLoadingIfNeeded)
        .overlay(content: makeEmptyViewIfNeeded)
        .overlay(content: makeErrorViewIfNeeded)
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
        .applyViewBackground()
    }

    @ViewBuilder
    private func makeAddButton() -> some View {
        Button(action: viewModel.onAddButtonTapped, label: {
            HStack(spacing: 4) {
                Text("Add phrase")
                    .apply(.medium, size: .L, color: .black)
                Image(systemName: "plus")
                    .apply(.semibold, size: .L, color: .black)
            }
            .padding(16)
            .background {
                UnevenRoundedRectangle(topLeadingRadius: 32, bottomLeadingRadius: 32)
                    .fill(appColor(.lightBlue).gradient)
            }
            .padding(.bottom, 16)
        })
        .opacity(viewModel.shouldShowAddButton ? 1 : 0)
    }

    @ViewBuilder
    private func makeLoadingIfNeeded() -> some View {
        if case .loading = viewModel.state {
            LoadingDotsView()
                .ignoresSafeArea()
        }
    }

    @ViewBuilder
    private func makeEmptyViewIfNeeded() -> some View {
        if case .empty = viewModel.state {
            ContentUnavailableView("Currently there are no phrases",
                                   systemImage: "nosign",
                                   description: Text("Add your first phrase."))
            .ignoresSafeArea()
        }
    }

    @ViewBuilder
    private func makeNotFoundViewIfNeeded() -> some View {
        if case .notFound = viewModel.state {
            ContentUnavailableView.search
                .ignoresSafeArea()
        }
    }

    @ViewBuilder
    private func makeErrorViewIfNeeded() -> some View {
        if case .failed = viewModel.state {
            ContentUnavailableView("Error Occurred",
                                   systemImage: "exclamationmark.circle.fill",
                                   description: Text("Unable to load data. Please try again."))
            .ignoresSafeArea()
        }
    }

    private func setupSegmentedControlAppearance() {
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(appColor(.paleOrange))
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor(appColor(.black))], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor(appColor(.paleOrange))], for: .normal)
    }
}

#if DEBUG
#Preview {
    ProjectDetailView(viewModel: .init(coordinator: PreviewCoordinator(), 
                                       project: .init(name: "",
                                                      technologies: [],
                                                      languages: [],
                                                      baseLanguage: .english,
                                                      members: [],
                                                      owner: "",
                                                      securedAlgoliaApiKey: "",
                                                      createdAt: .now,
                                                      algoliaIndexName: "")))
}
#endif
