//
//  ConfigurationRepository.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 15.02.24.
//

import Foundation
import Combine
import FirebaseRemoteConfig

public protocol ConfigurationRepository {

    var configUpdatePublisher: AnyPublisher<Void, Never> { get }

    func getValue(for key: ConfigurationRepositoryImpl.ConfigKey) -> RemoteConfigValue
}

public final class ConfigurationRepositoryImpl: ConfigurationRepository {

    public var configUpdatePublisher: AnyPublisher<Void, Never> {
        configUpdateSubject.eraseToAnyPublisher()
    }

    private let remoteConfig: RemoteConfig
    private let settings: RemoteConfigSettings

    private let configUpdateSubject = PassthroughSubject<Void, Never>()

    public init() {
        self.remoteConfig = RemoteConfig.remoteConfig()
        self.settings = .init()
        settings.minimumFetchInterval = 0
        remoteConfig.configSettings = settings
        remoteConfig.setDefaults(fromPlist: "RemoteConfigDefaults")
        fetchConfig()
        addOnConfigUpdateListener()
    }

    public func getValue(for key: ConfigKey) -> RemoteConfigValue {
        return remoteConfig.configValue(forKey: key.rawValue)
    }

    private func fetchConfig() {
        remoteConfig.fetch { [weak self] (status, error) -> Void in
            if status == .success {
                print("Config fetched!")
                self?.remoteConfig.activate()
                self?.configUpdateSubject.send()
            } else {
                print("Config not fetched")
                print("Error: \(error?.localizedDescription ?? "No error available.")")
            }
        }
    }

    private func addOnConfigUpdateListener() {
        remoteConfig.addOnConfigUpdateListener { [weak self] configUpdate, error in
            if let error {
                print("Error listening for config updates: \(error.localizedDescription)")
                return
            }
            self?.remoteConfig.activate()
            self?.configUpdateSubject.send()
        }
    }
}

extension ConfigurationRepositoryImpl {

    public enum ConfigKey: String {
        case versionUpdateInfo
        case privacyPolicyUrl
    }
}
