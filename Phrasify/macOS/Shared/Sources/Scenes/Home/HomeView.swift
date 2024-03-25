//
//  HomeView.swift
//  Phraseon_InHouse_MacOS
//
//  Created by Robert Adamczyk on 25.03.24.
//

import SwiftUI
import Model

struct HomeView: View {

    @StateObject private var viewModel: HomeViewModel

    init(coordinator: HomeViewModel.HomeCoordinator) {
        self._viewModel = .init(wrappedValue: .init(coordinator: coordinator))
    }

    private let columns = [
            GridItem(.flexible(), spacing: 32),
            GridItem(.flexible())
        ]

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 32) {
                LazyVGrid(columns: columns, spacing: 32) {
                    AddProjectCellView(action: viewModel.onAddProjectTapped)
                    ForEach(viewModel.projects, id: \.self) { project in
                        ProjectCellView(project: project, action: viewModel.onProjectTapped)
                    }
                }
            }
            .padding(32)
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
                    Spacer()
                    Text(project.technologies.joined)
                        .apply(.regular, size: .S, color: .lightGray)
                }
                Spacer()
            }
            .padding(32)
            .frame(height: 256)
            .applyCellBackground()
        })
        .buttonStyle(.plain)
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
                VStack(spacing: 32) {
                    Image(systemName: "plus")
                        .apply(.bold, size: .M, color: .paleOrange)
                    Text("Add project")
                        .apply(.bold, size: .L, color: .paleOrange)
                }
                Spacer()
            }
            .padding(32)
            .frame(height: 256)
            .applyCellBackground()
        })
        .buttonStyle(.plain)
    }
}
