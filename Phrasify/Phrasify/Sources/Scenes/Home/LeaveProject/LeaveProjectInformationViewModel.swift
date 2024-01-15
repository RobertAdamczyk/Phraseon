//
//  LeaveProjectInformationViewModel.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 16.01.24.
//

import SwiftUI

final class LeaveProjectInformationViewModel: StandardInformationProtocol {

    typealias LeaveProjectWarningCoordinator = Coordinator & SheetActions

    var title: String = "Action Required"

    var subtitle: String = "Before you can leave the project, you must transfer the ownership rights to another project member. This ensures continuous management and access control of the project. Please assign a new project owner before proceeding to leave."

    private let coordinator: LeaveProjectWarningCoordinator

    init(coordinator: LeaveProjectWarningCoordinator) {
        self.coordinator = coordinator
    }

    func onUnderstoodTapped() {
        coordinator.dismissSheet()
    }
}
