//
//  RootCoordinator.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 13.12.23.
//

import SwiftUI
import Combine

final class RootCoordinator: ObservableObject, Coordinator {

    @Published var navigationViews: [NavigationView] = []
    @Published var presentedFullScreenCover: FullScreenCover?

    var isLoggedIn: Bool? { dependencies.authenticationRepository.isLoggedIn }

    var dependencies: Dependencies

    private var cancelBag = CancelBag()

    init() {
        dependencies = .init(authenticationRepository: .init(), firestoreRepository: .init())
        setupLoginSubscription()
    }

    private func setupLoginSubscription() {
        dependencies.authenticationRepository.$isLoggedIn.sink { _ in
            self.objectWillChange.send()
        }
        .store(in: cancelBag)
    }
}

extension RootCoordinator: RootActions {

    func showProfile() {
        navigationViews.append(.profile)
    }

    func presentCreateProject() {
        presentedFullScreenCover = .createProject
    }

    func presentCreateKey(project: Project) {
        presentedFullScreenCover = .createKey(project)
    }

    func showProjectDetails(project: Project) {
        let viewModel = ProjectDetailViewModel(coordinator: self, project: project)
        let view: NavigationView = .projectDetails(viewModel: viewModel)
        navigationViews.append(view)
    }

    func dismissFullScreenCover() {
        presentedFullScreenCover = nil
    }
}

extension RootCoordinator {

    enum NavigationView: Identifiable, Hashable, Equatable {
        case profile
        case projectDetails(viewModel: ProjectDetailViewModel)

        static func == (lhs: RootCoordinator.NavigationView, rhs: RootCoordinator.NavigationView) -> Bool {
            lhs.id == rhs.id
        }

        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }

        var id: String {
            switch self {
            case .profile: return "001"
            case .projectDetails: return "002"
            }
        }
    }

    enum FullScreenCover: Identifiable {
        case createProject
        case createKey(Project)

        var id: String {
            switch self {
            case .createProject: "001"
            case .createKey: "002"
            }
        }
    }
}
