//
//  LeaveProjectWarningViewModel.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 07.01.24.
//

import SwiftUI

final class LeaveProjectWarningViewModel: ObservableObject {

    enum Context {
        case owner
        case notOwner
    }

    typealias LeaveProjectWarningCoordinator = Coordinator & SheetActions

    let context: Context

    private let coordinator: LeaveProjectWarningCoordinator

    init(coordinator: LeaveProjectWarningCoordinator, context: Context) {
        self.coordinator = coordinator
        self.context = context
    }

    @MainActor
    func onLeaveProjectTapped() async {

    }

    func onUnderstoodTapped() {
        coordinator.dismissSheet()
    }

    func onCancelTapped() {
        coordinator.dismissSheet()
    }
}

