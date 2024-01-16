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

    func createKey(projectId: String, keyId: String, translation: [String: String]) async throws {
        _ = try await functions.httpsCallable("createKey").call(["projectId": projectId,
                                                                 "keyId": keyId,
                                                                 "translation": translation] as [String : Any])
    }

    func changeContentKey(projectId: String, keyId: String, translation: [String: String]) async throws {
        _ = try await functions.httpsCallable("changeContentKey").call(["projectId": projectId,
                                                                        "keyId": keyId,
                                                                        "translation": translation] as [String : Any])
    }

    func leaveProject(projectId: String) async throws {
        _ = try await functions.httpsCallable("leaveProject").call(["projectId": projectId] as [String : Any])
    }

    func deleteKey(projectId: String, keyId: String) async throws {
        _ = try await functions.httpsCallable("deleteKey").call(["projectId": projectId,
                                                                    "keyId": keyId] as [String : Any])
    }

    func deleteProject(projectId: String) async throws {
        _ = try await functions.httpsCallable("deleteProject").call(["projectId": projectId] as [String : Any])
    }

    func isUserProjectOwner() async throws -> Bool {
        let result = try await functions.httpsCallable("isUserProjectOwner").call()

        if let data = result.data as? [String: Any], // I need to refactor this to make code clear
           let isOwner = data["isOwner"] as? Bool {
            return isOwner
        } else {
            throw AppError.decodingError
        }
    }
}
