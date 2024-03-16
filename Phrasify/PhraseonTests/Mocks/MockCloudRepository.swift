//
//  MockCloudRepository.swift
//  PhraseonTests
//
//  Created by Robert Adamczyk on 12.03.24.
//

import Foundation
@testable import Phraseon_InHouse_iOS
@testable import Model
@testable import Domain

final class MockCloudRepository: CloudRepository {

    var mockIsUserProjectOwner: Bool?

    func createProject(_ requestModel: Domain.CreateProjectService.RequestModel) async throws {
        // x
    }
    
    func changeProjectOwner(_ requestModel: Domain.ChangeProjectOwnerService.RequestModel) async throws {
        // x
    }
    
    func addProjectMember(_ requestModel: Domain.AddProjectMemberService.RequestModel) async throws {
        // x
    }
    
    func changeMemberRole(_ requestModel: Domain.ChangeMemberRoleService.RequestModel) async throws {
        // x
    }
    
    func deleteMember(_ requestModel: Domain.DeleteMemberService.RequestModel) async throws {
        // x
    }
    
    func setProjectLanguages(_ requestModel: Domain.SetProjectLanguagesService.RequestModel) async throws {
        // x
    }
    
    func setBaseLanguage(_ requestModel: Domain.SetBaseLanguageService.RequestModel) async throws {
        // x
    }
    
    func setProjectTechnologies(_ requestModel: Domain.SetProjectTechnologiesService.RequestModel) async throws {
        // x
    }
    
    func leaveProject(_ requestModel: Domain.LeaveProjectService.RequestModel) async throws {
        // x
    }
    
    func deleteProject(_ requestModel: Domain.DeleteProjectService.RequestModel) async throws {
        // x
    }
    
    func createKey(_ requestModel: Domain.CreateKeyService.RequestModel) async throws {
        // x
    }
    
    func changeContentKey(_ requestModel: Domain.ChangeContentKeyService.RequestModel) async throws {
        // x
    }
    
    func deleteKey(_ requestModel: Domain.DeleteKeyService.RequestModel) async throws {
        // x
    }
    
    func approveTranslation(_ requestModel: Domain.ApproveTranslationService.RequestModel) async throws {
        // x
    }
    
    func startTrial(_ requestModel: Domain.StartTrialService.RequestModel) async throws {
        // x
    }
    
    func isUserProjectOwner() async throws -> Domain.IsUserProjectOwnerService.ResponseModel {
        guard let mockIsUserProjectOwner else { fatalError("need mock") }
        return .init(isOwner: mockIsUserProjectOwner)
    }
}
