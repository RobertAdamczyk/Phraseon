//
//  PreviewLocalizationSyncRepository.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 05.05.24.
//

import Domain
import Model

final class PreviewLocalizationSyncRepository: LocalizationSyncRepository {
    func getSelectedTechnology(for project: Model.ProjectID) -> Model.Technology? {
        nil
    }
    
    func setSelectedTechnology(_ technology: Model.Technology, for project: Model.ProjectID) {
        // empty
    }
    
    func getPath(for association: Model.TechnologyProjectAssociation) -> String? {
        nil
    }
    
    func setPath(_ path: String, for association: Model.TechnologyProjectAssociation) {
        // empty
    }
}
