//
//  SyncScript.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 15.01.24.
//

import SwiftUI
import UniformTypeIdentifiers

struct SyncScript: FileDocument {
    // tell the system we support only plain text
    static var readableContentTypes = [UTType.shellScript]

    // by default our document is empty
    var script: String

    // a simple initializer that creates new, empty documents
    init?(userId: UserID?, projectId: String?) {
        guard let userId, let projectId, let filePath = Bundle.main.path(forResource: "syncScript", ofType: "txt") else { return nil }

        do {
            let syncScript = try String(contentsOfFile: filePath, encoding: .utf8)
            self.script = syncScript
                .replacingOccurrences(of: "ACCESS_TOKEN_VALUE", with: userId)
                .replacingOccurrences(of: "PROJECT_ID_VALUE", with: projectId)
        } catch {
            print("Error loading file: \(error)")
            return nil
        }
    }

    // this initializer loads data that has been saved previously
    init(configuration: ReadConfiguration) throws {
        fatalError("Not needed.")
    }

    // this will be called when the system wants to write our data to disk
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let data = Data(script.utf8)
        return FileWrapper(regularFileWithContents: data)
    }
}
