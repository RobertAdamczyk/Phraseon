//
//  TranslationApprovalUseCase.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 31.01.24.
//

import Foundation
import Model

struct TranslationApprovalUseCase {

    let project: Project
    let subscriptionPlan: SubscriptionPlan?

    var shouldShow: Bool {
        return project.members.count > 1
    }
}
