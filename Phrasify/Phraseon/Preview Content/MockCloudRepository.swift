//
//  PreviewCloudRepository.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 20.02.24.
//

import Foundation

final class PreviewCloudRepository: CloudRepository {

    func createProject(_ requestModel: CreateProjectService.RequestModel) async throws {
        // empty
    }
    
    func changeProjectOwner(_ requestModel: ChangeProjectOwnerService.RequestModel) async throws {
        // empty
    }
    
    func addProjectMember(_ requestModel: AddProjectMemberService.RequestModel) async throws {
        // empty
    }
    
    func changeMemberRole(_ requestModel: ChangeMemberRoleService.RequestModel) async throws {
        // empty
    }
    
    func deleteMember(_ requestModel: DeleteMemberService.RequestModel) async throws {
        // empty
    }
    
    func setProjectLanguages(_ requestModel: SetProjectLanguagesService.RequestModel) async throws {
        // empty
    }
    
    func setBaseLanguage(_ requestModel: SetBaseLanguageService.RequestModel) async throws {
        // empty
    }
    
    func setProjectTechnologies(_ requestModel: SetProjectTechnologiesService.RequestModel) async throws {
        // empty
    }
    
    func leaveProject(_ requestModel: LeaveProjectService.RequestModel) async throws {
        // empty
    }
    
    func deleteProject(_ requestModel: DeleteProjectService.RequestModel) async throws {
        // empty
    }
    
    func createKey(_ requestModel: CreateKeyService.RequestModel) async throws {
        // empty
    }
    
    func changeContentKey(_ requestModel: ChangeContentKeyService.RequestModel) async throws {
        // empty
    }
    
    func deleteKey(_ requestModel: DeleteKeyService.RequestModel) async throws {
        // empty
    }
    
    func approveTranslation(_ requestModel: ApproveTranslationService.RequestModel) async throws {
        // empty
    }
    
    func startTrial(_ requestModel: StartTrialService.RequestModel) async throws {
        // empty
    }
    
    func isUserProjectOwner() async throws -> IsUserProjectOwnerService.ResponseModel {
        return .init(isOwner: true)
    }
}
