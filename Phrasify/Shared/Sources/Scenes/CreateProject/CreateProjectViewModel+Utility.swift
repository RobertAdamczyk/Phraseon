//
//  CreateProjectViewModel+ViewModel.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 30.03.24.
//

import Foundation

extension CreateProjectViewModel {

    struct Utility {

        let projectName: String

        var shouldPrimaryButtonDisabled: Bool {
            projectName.count < 3
        }
    }
}
