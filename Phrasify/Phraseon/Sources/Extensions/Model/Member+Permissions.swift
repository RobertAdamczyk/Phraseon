//
//  Member+Permissions.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 18.01.24.
//

import Foundation

extension Member {

    var hasPermissionToChangeOwner: Bool {
        switch role {
        case .owner: true
        case .admin, .developer, .viewer, .marketing: false
        }
    }

    var hasPermissionToManageMembers: Bool {
        switch role {
        case .owner, .admin: true
        case .developer, .viewer, .marketing: false
        }
    }

    var hasPermissionToDeleteProject: Bool {
        switch role {
        case .owner: true
        case .admin, .developer, .viewer, .marketing: false
        }
    }

    var hasPermissionToDeleteKey: Bool {
        switch role {
        case .owner, .admin, .developer: true
        case .viewer, .marketing: false
        }
    }

    var hasPermissionToEditContentKey: Bool {
        switch role {
        case .owner, .admin, .developer, .marketing: true
        case .viewer: false
        }
    }

    var hasPermissionToChangeLanguages: Bool {
        switch role {
        case .owner, .admin: true
        case .developer, .viewer, .marketing: false
        }
    }

    var hasPermissionToChangeTechnologies: Bool {
        switch role {
        case .owner, .admin: true
        case .developer, .viewer, .marketing: false
        }
    }

    var hasPermissionToAddKey: Bool {
        switch role {
        case .owner, .admin, .developer: true
        case .viewer, .marketing: false
        }
    }

    var hasPermissionToApproveKey: Bool {
        switch role {
        case .owner, .admin, .marketing: true
        case .developer, .viewer: false
        }
    }
}
