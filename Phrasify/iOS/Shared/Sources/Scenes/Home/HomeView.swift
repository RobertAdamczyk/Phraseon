//
//  HomeView.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 14.12.23.
//

import SwiftUI
import Model

struct HomeView: View {

    @StateObject private var viewModel: HomeViewModel

    init(coordinator: HomeViewModel.HomeCoordinator) {
        self._viewModel = .init(wrappedValue: .init(coordinator: coordinator))
    }

    private let columns = [
            GridItem(.flexible(), spacing: 16),
            GridItem(.flexible())
        ]

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 16) {
                LazyVGrid(columns: columns, spacing: 16) {
                    AddProjectCellView(action: viewModel.onAddProjectTapped)
                    ForEach(viewModel.projects, id: \.self) { project in
                        ProjectCellView(project: project, action: viewModel.onProjectTapped)
                    }
                }
            }
            .padding(16)
        }
        .ignoresSafeArea(edges: .bottom)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: viewModel.onProfileTapped, label: {
                    Image(systemName: "person.fill")
                        .apply(.bold, size: .L, color: .paleOrange)
                })
            }
        }
        .navigationTitle("Projects")
        .applyViewBackground()
    }
}

struct ProjectCellView: View {

    let project: Project
    let action: (Project) -> Void

    var body: some View {
        Button(action: executeAction, label: {
            HStack {
                VStack(alignment: .leading, spacing: 64) {
                    Text(project.name)
                        .apply(.bold, size: .M, color: .white)
                    Text(project.technologies.joined)
                        .apply(.regular, size: .S, color: .lightGray)
                }
                Spacer()
            }
            .padding(16)
            .frame(height: 128)
            .applyCellBackground()
        })
    }

    private func executeAction() {
        action(project)
    }
}

struct AddProjectCellView: View {

    let action: () -> Void

    var body: some View {
        Button(action: action, label: {
            HStack {
                Spacer()
                VStack(spacing: 16) {
                    Image(systemName: "plus")
                        .apply(.bold, size: .M, color: .paleOrange)
                    Text("Add project")
                        .apply(.bold, size: .L, color: .paleOrange)
                }
                Spacer()
            }
            .padding(16)
            .frame(height: 128)
            .applyCellBackground()
        })
    }
}

#if DEBUG
#Preview {
    HomeView(coordinator: PreviewCoordinator())
        .preferredColorScheme(.dark)
}
#endif
