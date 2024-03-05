//
//  PreviewConfigurationRepository.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 20.02.24.
//

import Foundation
import Combine
import FirebaseRemoteConfig
import Domain

final class PreviewConfigurationRepository: ConfigurationRepository {

    private let configUpdateSubject = PassthroughSubject<Void, Never>()

    var configUpdatePublisher: AnyPublisher<Void, Never> {
        configUpdateSubject.eraseToAnyPublisher()
    }

    func getValue(for key: ConfigurationRepositoryImpl.ConfigKey) -> RemoteConfigValue {
        return .init()
    }
}
