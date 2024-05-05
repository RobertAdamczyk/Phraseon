//
//  File.swift
//  
//
//  Created by Robert Adamczyk on 05.05.24.
//

import Model
import Foundation
import SwiftUI

public protocol LocalizationSyncRepository {

    func getSelectedTechnology(for project: ProjectID) -> Technology?

    func setSelectedTechnology(_ technology: Technology, for project: ProjectID)

    func getPath(for association: TechnologyProjectAssociation) -> String?

    func setPath(_ path: String, for association: TechnologyProjectAssociation)
}

public final class LocalizationSyncRepositoryImpl: LocalizationSyncRepository {

    @AppStorage("selectedTechnologyStorage") private var selectedTechnologyStorage: Data = .init()
    @AppStorage("pathStorage") private var pathStorage: Data = .init()

    private var selectedTechnologyData: [ProjectID: Technology] {
        get {
            guard let data = try? JSONDecoder().decode([ProjectID: Technology].self, from: selectedTechnologyStorage) else {
                return [:]
            }
            return data
        }
        set {
            if let encoded = try? JSONEncoder().encode(newValue) {
                selectedTechnologyStorage = encoded
            }
        }
    }

    private var pathData: [TechnologyProjectAssociation: String] {
        get {
            guard let data = try? JSONDecoder().decode([TechnologyProjectAssociation: String].self, from: pathStorage) else {
                return [:]
            }
            return data
        }
        set {
            if let encoded = try? JSONEncoder().encode(newValue) {
                pathStorage = encoded
            }
        }
    }

    public init() {

    }

    public func getSelectedTechnology(for project: ProjectID) -> Technology? {
        selectedTechnologyData[project]
    }

    public func setSelectedTechnology(_ technology: Model.Technology, for project: ProjectID) {
        selectedTechnologyData[project] = technology
    }

    public func getPath(for association: TechnologyProjectAssociation) -> String? {
        pathData[association]
    }

    public func setPath(_ path: String, for association: TechnologyProjectAssociation) {
        pathData[association] = path
    }
}
