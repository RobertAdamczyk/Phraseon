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

    let data = (1...100).map { "\($0)" }

    let columns = [
            GridItem(.flexible(), spacing: 16),
            GridItem(.flexible())
        ]

    var body: some View {
        VStack(alignment: .leading) {
            Text("Projects")
                .apply(.bold, size: .H1, color: .white)
            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: columns, spacing: 16) {
                    AddProjectCellView(action: viewModel.onAddProjectTapped)
                    ForEach(data, id: \.self) { item in
                        ProjectCellView(project: .init(name: "\(item)"), action: viewModel.onProjectTapped)
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
            .padding(.vertical, 24)
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
