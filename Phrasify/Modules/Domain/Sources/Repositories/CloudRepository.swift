//
//  CloudRepository.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 27.12.23.
//

import FirebaseFunctions
import Foundation

public protocol CloudRepository {

    func createProject(_ requestModel: CreateProjectService.RequestModel) async throws

    func changeProjectOwner(_ requestModel: ChangeProjectOwnerService.RequestModel) async throws

    func addProjectMember(_ requestModel: AddProjectMemberService.RequestModel) async throws

    func changeMemberRole(_ requestModel: ChangeMemberRoleService.RequestModel) async throws

    func deleteMember(_ requestModel: DeleteMemberService.RequestModel) async throws

    func setProjectLanguages(_ requestModel: SetProjectLanguagesService.RequestModel) async throws

    func setBaseLanguage(_ requestModel: SetBaseLanguageService.RequestModel) async throws

    func setProjectTechnologies(_ requestModel: SetProjectTechnologiesService.RequestModel) async throws

    func leaveProject(_ requestModel: LeaveProjectService.RequestModel) async throws

    func deleteProject(_ requestModel: DeleteProjectService.RequestModel) async throws

    func createKey(_ requestModel: CreateKeyService.RequestModel) async throws

    func changeContentKey(_ requestModel: ChangeContentKeyService.RequestModel) async throws

    func deleteKey(_ requestModel: DeleteKeyService.RequestModel) async throws

    func approveTranslation(_ requestModel: ApproveTranslationService.RequestModel) async throws

    func startTrial(_ requestModel: StartTrialService.RequestModel) async throws

    func isUserProjectOwner() async throws -> IsUserProjectOwnerService.ResponseModel
}

public final class CloudRepositoryImpl: CloudRepository {

    public init() { }

    private let functions = Functions.functions()

    public func createProject(_ requestModel: CreateProjectService.RequestModel) async throws {
        let service: CreateProjectService = .init(requestModel: requestModel)
        _ = try await functions.httpsCallable(service.functionName).call(service.getParameters())
    }

    public func changeProjectOwner(_ requestModel: ChangeProjectOwnerService.RequestModel) async throws {
        let service: ChangeProjectOwnerService = .init(requestModel: requestModel)
        _ = try await functions.httpsCallable(service.functionName).call(service.getParameters())
    }

    public func addProjectMember(_ requestModel: AddProjectMemberService.RequestModel) async throws {
        let service: AddProjectMemberService = .init(requestModel: requestModel)
        _ = try await functions.httpsCallable(service.functionName).call(service.getParameters())
    }

    public func changeMemberRole(_ requestModel: ChangeMemberRoleService.RequestModel) async throws {
        let service: ChangeMemberRoleService = .init(requestModel: requestModel)
        _ = try await functions.httpsCallable(service.functionName).call(service.getParameters())
    }

    public func deleteMember(_ requestModel: DeleteMemberService.RequestModel) async throws {
        let service: DeleteMemberService = .init(requestModel: requestModel)
        _ = try await functions.httpsCallable(service.functionName).call(service.getParameters())
    }

    public func setProjectLanguages(_ requestModel: SetProjectLanguagesService.RequestModel) async throws {
        let service: SetProjectLanguagesService = .init(requestModel: requestModel)
        _ = try await functions.httpsCallable(service.functionName).call(service.getParameters())
    }

    public func setBaseLanguage(_ requestModel: SetBaseLanguageService.RequestModel) async throws {
        let service: SetBaseLanguageService = .init(requestModel: requestModel)
        _ = try await functions.httpsCallable(service.functionName).call(service.getParameters())
    }

    public func setProjectTechnologies(_ requestModel: SetProjectTechnologiesService.RequestModel) async throws {
        let service: SetProjectTechnologiesService = .init(requestModel: requestModel)
        _ = try await functions.httpsCallable(service.functionName).call(service.getParameters())
    }

    public func leaveProject(_ requestModel: LeaveProjectService.RequestModel) async throws {
        let service: LeaveProjectService = .init(requestModel: requestModel)
        _ = try await functions.httpsCallable(service.functionName).call(service.getParameters())
    }

    public func deleteProject(_ requestModel: DeleteProjectService.RequestModel) async throws {
        let service: DeleteProjectService = .init(requestModel: requestModel)
        _ = try await functions.httpsCallable(service.functionName).call(service.getParameters())
    }

    public func createKey(_ requestModel: CreateKeyService.RequestModel) async throws {
        let service: CreateKeyService = .init(requestModel: requestModel)
        _ = try await functions.httpsCallable(service.functionName).call(service.getParameters())
    }

    public func changeContentKey(_ requestModel: ChangeContentKeyService.RequestModel) async throws {
        let service: ChangeContentKeyService = .init(requestModel: requestModel)
        _ = try await functions.httpsCallable(service.functionName).call(service.getParameters())
    }

    public func deleteKey(_ requestModel: DeleteKeyService.RequestModel) async throws {
        let service: DeleteKeyService = .init(requestModel: requestModel)
        _ = try await functions.httpsCallable(service.functionName).call(service.getParameters())
    }

    public func approveTranslation(_ requestModel: ApproveTranslationService.RequestModel) async throws {
        let service: ApproveTranslationService = .init(requestModel: requestModel)
        _ = try await functions.httpsCallable(service.functionName).call(service.getParameters())
    }

    public func startTrial(_ requestModel: StartTrialService.RequestModel) async throws {
        let service: StartTrialService = .init(requestModel: requestModel)
        _ = try await functions.httpsCallable(service.functionName).call(service.getParameters())
    }

    public func isUserProjectOwner() async throws -> IsUserProjectOwnerService.ResponseModel {
        let service: IsUserProjectOwnerService = .init(requestModel: .init())
        let result = try await functions.httpsCallable(service.functionName).call()
        return try .decode(from: result.data)
    }
}
