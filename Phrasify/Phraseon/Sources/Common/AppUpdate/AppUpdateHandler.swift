//
//  AppUpdateHandler.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 15.02.24.
//

import SwiftUI
import Common

final class AppUpdateHandler {

    typealias Updates = [String: UpdateInfo]

    struct UpdateInfo: Codable {
        let title: String
        let message: String
        let confirmButtonText: String
        let url: String
    }

    @Published private(set) var updateInfo: UpdateInfo?
    @AppStorage(UserDefaults.Key.updateInfoData.rawValue) private var updateInfoData: Data = .init()

    private let configurationRepository: ConfigurationRepository
    private let cancelBag = CancelBag()

    init(configurationRepository: ConfigurationRepository) {
        self.configurationRepository = configurationRepository
        observeConfigUpdates()
        checkForMandatoryUpdate(updateInfoData)
    }

    private func observeConfigUpdates() {
        configurationRepository.configUpdatePublisher
            .sink { [weak self] in
                guard let self else { return }
                updateInfoData = configurationRepository.getValue(for: .versionUpdateInfo).dataValue
                checkForMandatoryUpdate(updateInfoData)
            }
            .store(in: cancelBag)
    }

    private func checkForMandatoryUpdate(_ data: Data) {
        let decoder = JSONDecoder()
        let updates = try? decoder.decode(Updates.self, from: data)
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        let testFlightSuffix = Bundle.main.appStoreReceiptURL?.lastPathComponent == "sandboxReceipt" ? "_TF" : ""

        if let appVersion, let updateInfo = updates?[appVersion + testFlightSuffix] {
            self.updateInfo = updateInfo
        } else {
            self.updateInfo = nil
        }
    }
}
