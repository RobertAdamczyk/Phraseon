//
//  SyncScript.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 15.01.24.
//

import SwiftUI
import UniformTypeIdentifiers
import Zip
import Model

struct SyncScript: FileDocument {

    static let readableContentTypes = [UTType.zip]
    static let scriptFileName: String = "syncScript.sh"
    static let zipFileName: String = "syncScript.zip"

    var url: URL

    init?(userId: UserID?, projectId: String?) {
        guard let userId, let projectId, let filePath = Bundle.main.path(forResource: "syncScript", ofType: "txt") else { return nil }
        guard let path = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist"),
              let nsDictionary = NSDictionary(contentsOfFile: path),
              let firebaseProjectId = nsDictionary["PROJECT_ID"] as? String else { return nil }
        let fileManager = FileManager.default
        let scriptFileURL = fileManager.temporaryDirectory.appendingPathComponent(Self.scriptFileName)
        let zipFileURL = fileManager.temporaryDirectory.appendingPathComponent(Self.zipFileName)

        do {
            let syncScript = try String(contentsOfFile: filePath, encoding: .utf8)
            let scriptWithCredentials = syncScript
                .replacingOccurrences(of: "ACCESS_TOKEN_VALUE", with: userId)
                .replacingOccurrences(of: "PROJECT_ID_VALUE", with: projectId)
                .replacingOccurrences(of: "FIREBASE_PROJECT_ID", with: firebaseProjectId)

            try scriptWithCredentials.write(to: scriptFileURL, atomically: true, encoding: .utf8)

            try Zip.zipFiles(paths: [scriptFileURL], zipFilePath: zipFileURL, password: nil, progress: nil)

            self.url = zipFileURL
        } catch {
            print("Error loading file: \(error)")
            return nil
        }
    }

    // this initializer loads data that has been saved previously
    init(configuration: ReadConfiguration) throws {
        fatalError("Not needed.")
    }

    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        try .init(url: url)
    }
}
