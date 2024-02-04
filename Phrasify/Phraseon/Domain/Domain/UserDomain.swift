//
//  UserDomain.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 28.01.24.
//

import Foundation
import SwiftUI

protocol UserDomainProtocol: AnyObject {

    var user: User? { set get }
    var cancelBag: CancelBag { get }
    var userDomain: UserDomain { get }

    func setupUserSubscriber()
}

extension UserDomainProtocol {

    func setupUserSubscriber() {
        userDomain.$user
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] user in
                DispatchQueue.main.async {
                    self?.user = user
                }
            })
            .store(in: cancelBag)
    }
}

final class UserDomain {

    @Published private(set) var user: User?

    private let firestoreRepository: FirestoreRepository
    private let authenticationRepository: AuthenticationRepository

    private let loginCancelBag = CancelBag()
    private let cancelBag = CancelBag()

    init(firestoreRepository: FirestoreRepository, authenticationRepository: AuthenticationRepository) {
        self.firestoreRepository = firestoreRepository
        self.authenticationRepository = authenticationRepository
        setupLoginSubscription()
    }

    private func setupUserSubscriber() {
        guard let userId = authenticationRepository.currentUser?.uid else { return }
        cancelBag.cancel()
        firestoreRepository.getUserPublisher(userId: userId)
            .receive(on: RunLoop.main)
            .sink { _ in
                // empty implementation
            } receiveValue: { [weak self] user in
                DispatchQueue.main.async {
                    self?.user = user
                }
            }
            .store(in: cancelBag)
    }

    private func setupLoginSubscription() {
        authenticationRepository.$isLoggedIn.sink { [weak self] isLoggedIn in
            self?.cancelBag.cancel()
            self?.user = nil
            if isLoggedIn == true {
                self?.setupUserSubscriber()
            }
        }
        .store(in: loginCancelBag)
    }
}
