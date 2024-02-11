//
//  TranslationApprovalUseCase.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 31.01.24.
//

import Foundation

struct TranslationApprovalUseCase {

    let project: Project
    let subscriptionPlan: SubscriptionPlan?

    var shouldShow: Bool {
        return project.members.count == 1 && subscriptionPlan == .team
    }
}
