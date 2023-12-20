//
//  HomeView.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 14.12.23.
//

import SwiftUI

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
        VStack(alignment: .leading) {
            AppTitle(title: "Projects")
            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: columns, spacing: 16) {
                    AddProjectCellView(action: viewModel.onAddProjectTapped)
                    ForEach(viewModel.projects, id: \.self) { project in
                        ProjectCellView(project: project, action: viewModel.onProjectTapped)
                    }
                }
            }
            .ignoresSafeArea(edges: .bottom)
        }
        .padding(16)
        .background(appColor(.black))
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: viewModel.onProfileTapped, label: {
                    Image(systemName: "person.fill")
                        .apply(.bold, size: .L, color: .paleOrange)
                })
            }
        }
    }
}

struct ProjectCellView: View {

    let project: Project
    let action: () -> Void

    var body: some View {
        Button(action: action, label: {
            HStack {
                VStack(alignment: .leading, spacing: 64) {
                    Text(project.name)
                        .apply(.bold, size: .M, color: .white)
                    Text(project.id ?? "")
                        .apply(.regular, size: .S, color: .white)
                }
                Spacer()
            }
            .padding(16)
            .frame(height: 128)
            .background {
                appColor(.darkGray).opacity(0.5)
            }
            .clipShape(RoundedRectangle(cornerRadius: 8))
        })
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
            .background {
                appColor(.darkGray).opacity(0.5)
            }
            .clipShape(RoundedRectangle(cornerRadius: 8))
        })
    }
}

#Preview {
    HomeView(coordinator: MockCoordinator())
}
