//
//  LoginViewModel.swift
//  Phraseon_InHouse_MacOS
//
//  Created by Robert Adamczyk on 16.03.24.
//

import SwiftUI

final class LoginViewModel: ObservableObject {

    typealias LoginCoordinator = Coordinator

    @Published var email: String = ""
    @Published var password: String = ""

    private let coordinator: LoginCoordinator

    init(coordinator: LoginCoordinator) {
        self.coordinator = coordinator
    }
}
