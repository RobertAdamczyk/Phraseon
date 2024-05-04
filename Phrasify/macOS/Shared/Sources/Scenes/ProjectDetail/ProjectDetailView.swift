//
//  ProjectDetailView.swift
//  Phraseon_InHouse_MacOS
//
//  Created by Robert Adamczyk on 10.04.24.
//

import SwiftUI
import Model

struct ProjectDetailView: View {

    @ObservedObject var viewModel: ProjectDetailViewModel

    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(alignment: .leading, spacing: 24) {
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
                        .buttonStyle(.plain)
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
                        .buttonStyle(.plain)
                    }
                default: EmptyView()
                }
                Spacer().frame(height: 100)
            }
            .scrollTargetLayout()
            .padding(32)
        }
        .overlay(alignment: .bottom, content: makeButtons)
        .opacity(viewModel.shouldShowContent ? 1 : 0)
        .overlay(content: makeNotFoundViewIfNeeded)
        .searchable(text: $viewModel.searchText, isPresented: $viewModel.isSearchPresented)
        .overlay(content: makeLoadingIfNeeded)
        .overlay(content: makeEmptyViewIfNeeded)
        .overlay(content: makeErrorViewIfNeeded)
        .navigationTitle(viewModel.project.name)
        .applyViewBackground()
        .toolbar {
            ToolbarItem(placement: .destructiveAction) {
                Button(action: viewModel.onSettingsTapped, label: {
                    Image(systemName: "gearshape")
                        .apply(.bold, size: .L, color: .white)
                })
            }
        }
    }

    @ViewBuilder
    private var syncContent: some View {
        AppButton(style: .fill("Sync phrases", .lightBlue), action: .async(viewModel.syncManager.synchronizeKeys))
        VStack(alignment: .leading, spacing: 4) {
            Text("For selected technology:")
                .apply(.regular, size: .S, color: .lightGray)
                .padding(.horizontal, 8)
            Picker("", selection: $viewModel.syncManager.selectedTechnology) {
                ForEach(Technology.allCases, id: \.self) { technology in
                    Text("\(technology.title)")
                }
            }
            .pickerStyle(.menu)
            .frame(width: 128)
            .tint(appColor(.lightBlue))
        }
    }

    @ViewBuilder
    private func makeLoadingIfNeeded() -> some View {
        if case .loading = viewModel.state {
            LoadingDotsView()
                .frame(height: 200)
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

    private func makeButtons() -> some View {
        HStack(spacing: 8) {
            syncContent
            Spacer()
            AppButton(style: .fill("Add phrase", .lightBlue), action: .main(viewModel.onAddButtonTapped))
                .opacity(viewModel.shouldShowAddButton ? 1 : 0)
        }
        .padding(.horizontal, 32)
        .padding(.vertical, 24)
        .background(.regularMaterial)
        .overlay(alignment: .top) {
            Rectangle().frame(height: 1)
                .foregroundStyle(appColor(.black))
        }
    }
}
