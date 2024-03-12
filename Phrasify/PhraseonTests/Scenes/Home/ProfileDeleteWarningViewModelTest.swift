//
//  ProfileDeleteWarningViewModelTest.swift
//  PhraseonTests
//
//  Created by Robert Adamczyk on 12.03.24.
//

import XCTest
import Combine
@testable import Phraseon_InHouse
@testable import Model
@testable import Common
@testable import Domain
@testable import FirebaseStorage

final class ProfileDeleteWarningViewModelTest: XCTestCase {

    private let coordinator = ProfileDeleteWarningCoordinator()

    private var cloudRepo: MockCloudRepository? {
        coordinator.dependencies.cloudRepository as? MockCloudRepository
    }

    private var authRepo: MockAuthenticationRepository? {
        coordinator.dependencies.authenticationRepository as? MockAuthenticationRepository
    }

    private let cancelBag = CancelBag()

    func testFlow() throws {
        let viewModel = ProfileDeleteWarningViewModel(coordinator: coordinator)
        XCTAssertEqual(viewModel.state, .deletion)

        let expectationLoading = XCTestExpectation()
        let expectationInformation = XCTestExpectation()
        viewModel.$state.sink { state in
            switch state {
            case .loading: 
                expectationLoading.fulfill()
            case .information:
                expectationInformation.fulfill()
            case .deletion:
                break
            }
        }
        .store(in: cancelBag)

        cloudRepo?.mockIsUserProjectOwner = true

        Task {
            await viewModel.onDeleteAccountTapped()
            await fulfillment(of: [expectationLoading], timeout: 1.0)
            await fulfillment(of: [expectationInformation], timeout: 1.0)
            XCTAssertEqual(viewModel.state, .information)
            coordinator.calledDismissSheet = nil
            viewModel.onUnderstoodTapped()
            XCTAssertEqual(coordinator.calledDismissSheet, true)

            coordinator.calledDismissSheet = nil
            viewModel.onCancelTapped()
            XCTAssertEqual(coordinator.calledDismissSheet, true)

            coordinator.calledDismissSheet = nil
            cloudRepo?.mockIsUserProjectOwner = false
            await viewModel.onDeleteAccountTapped()
            XCTAssertEqual(authRepo?.calledDeleteUser, true)
            XCTAssertEqual(coordinator.calledDismissSheet, true)
        }
    }
}

fileprivate final class ProfileDeleteWarningCoordinator: ProfileDeleteWarningViewModel.ProfileDeleteWarningCoordinator {

    var calledDismissSheet: Bool?

    var dependencies: Dependencies = MockDependencies.makeDependencies(authenticationRepository: MockAuthenticationRepository(),
                                                                       cloudRepository: MockCloudRepository())

    func dismissSheet() {
        self.calledDismissSheet = true
    }
}
