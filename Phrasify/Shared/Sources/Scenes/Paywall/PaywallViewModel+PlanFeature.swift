//
//  PaywallViewModel+PlanFeature.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 07.04.24.
//

import Foundation

extension PaywallViewModel {

    enum PlanFeature: CaseIterable {
        case support
        case translation
        case collaboration
        case management

        var description: String {
            switch self {
            case .support:
                return "Get 24/7 support for any issue."
            case .translation:
                return "Enjoy seamless translations in numerous languages."
            case .collaboration:
                return "Collaborate effectively with team members."
            case .management:
                return "Manage projects effortlessly with unlimited access."
            }
        }
    }
}
