//
//  CloudRepository.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 27.12.23.
//

import FirebaseFunctions
import Foundation

final class CloudRepository {

    private let functions = Functions.functions()

    func createProject(_ requestModel: CreateProjectService.RequestModel) async throws {
        let service: CreateProjectService = .init(requestModel: requestModel)
        _ = try await functions.httpsCallable(service.functionName).call(service.getParameters())
    }

    func changeProjectOwner(_ requestModel: ChangeProjectOwnerService.RequestModel) async throws {
        let service: ChangeProjectOwnerService = .init(requestModel: requestModel)
        _ = try await functions.httpsCallable(service.functionName).call(service.getParameters())
    }

    func addProjectMember(_ requestModel: AddProjectMemberService.RequestModel) async throws {
        let service: AddProjectMemberService = .init(requestModel: requestModel)
        _ = try await functions.httpsCallable(service.functionName).call(service.getParameters())
    }

    func changeMemberRole(_ requestModel: ChangeMemberRoleService.RequestModel) async throws {
        let service: ChangeMemberRoleService = .init(requestModel: requestModel)
        _ = try await functions.httpsCallable(service.functionName).call(service.getParameters())
    }

    func deleteMember(_ requestModel: DeleteMemberService.RequestModel) async throws {
        let service: DeleteMemberService = .init(requestModel: requestModel)
        _ = try await functions.httpsCallable(service.functionName).call(service.getParameters())
    }

    func setProjectLanguages(_ requestModel: SetProjectLanguagesService.RequestModel) async throws {
        let service: SetProjectLanguagesService = .init(requestModel: requestModel)
        _ = try await functions.httpsCallable(service.functionName).call(service.getParameters())
    }

    func setProjectTechnologies(_ requestModel: SetProjectTechnologiesService.RequestModel) async throws {
        let service: SetProjectTechnologiesService = .init(requestModel: requestModel)
        _ = try await functions.httpsCallable(service.functionName).call(service.getParameters())
    }

    func leaveProject(_ requestModel: LeaveProjectService.RequestModel) async throws {
        let service: LeaveProjectService = .init(requestModel: requestModel)
        _ = try await functions.httpsCallable(service.functionName).call(service.getParameters())
    }

    func deleteProject(_ requestModel: DeleteProjectService.RequestModel) async throws {
        let service: DeleteProjectService = .init(requestModel: requestModel)
        _ = try await functions.httpsCallable(service.functionName).call(service.getParameters())
    }

    func createKey(_ requestModel: CreateKeyService.RequestModel) async throws {
        let service: CreateKeyService = .init(requestModel: requestModel)
        _ = try await functions.httpsCallable(service.functionName).call(service.getParameters())
    }

    func changeContentKey(_ requestModel: ChangeContentKeyService.RequestModel) async throws {
        let service: ChangeContentKeyService = .init(requestModel: requestModel)
        _ = try await functions.httpsCallable(service.functionName).call(service.getParameters())
    }

    func deleteKey(_ requestModel: DeleteKeyService.RequestModel) async throws {
        let service: DeleteKeyService = .init(requestModel: requestModel)
        _ = try await functions.httpsCallable(service.functionName).call(service.getParameters())
    }

    func isUserProjectOwner() async throws -> Bool {
        let service: IsUserProjectOwnerService = .init(requestModel: .init())
        let result = try await functions.httpsCallable(service.functionName).call()

        if let data = result.data as? [String: Any], // I need to refactor this to make code clear
           let isOwner = data["isOwner"] as? Bool {
            return isOwner
        } else {
            throw AppError.decodingError
        }
    }
}
