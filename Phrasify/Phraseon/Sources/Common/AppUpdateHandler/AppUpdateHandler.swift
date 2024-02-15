//
//  AppUpdateHandler.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 15.02.24.
//

import Foundation

final class AppUpdateHandler: ObservableObject {

    typealias Updates = [String: UpdateInfo]

    struct UpdateInfo: Codable {
        let isMandatory: Bool
        let message: String
    }

    @Published private(set) var updateInfo: UpdateInfo?

    private let configurationRepository: ConfigurationRepository
    private let cancelBag = CancelBag()

    init(configurationRepository: ConfigurationRepository) {
        self.configurationRepository = configurationRepository
        observeConfigUpdates()
    }

    private func observeConfigUpdates() {
        configurationRepository.configUpdatePublisher
            .sink { [weak self] in
                self?.checkForMandatoryUpdate()
            }
            .store(in: cancelBag)
    }

    private func checkForMandatoryUpdate() {
        let decoder = JSONDecoder()
        let updateData = configurationRepository.getValue(for: .versionUpdateInfo).dataValue
        let updates = try? decoder.decode(Updates.self, from: updateData)
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        let testFlightSuffix = Bundle.main.appStoreReceiptURL?.lastPathComponent == "sandboxReceipt" ? "_TF" : ""

        if let appVersion, let updateInfo = updates?[appVersion + testFlightSuffix] {
            self.updateInfo = updateInfo
            print("UPDATE FOUND")
        } else {
            print("UPDATE NOT FOUND")
        }
    }
}
