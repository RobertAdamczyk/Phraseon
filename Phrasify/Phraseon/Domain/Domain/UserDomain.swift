//
//  UserDomain.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 28.01.24.
//

import Foundation
import SwiftUI

protocol UserDomainProtocol: AnyObject {

    var user: DeferredData<User> { set get }
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

    @Published private(set) var user: DeferredData<User> = .idle

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
        user = .isLoading
        firestoreRepository.getUserPublisher(userId: userId)
            .receive(on: RunLoop.main)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    DispatchQueue.main.async {
                        self?.user = .failed(error)
                    }
                }
            } receiveValue: { [weak self] user in
                DispatchQueue.main.async {
                    if let user {
                        self?.user = .loaded(user)
                    } else {
                        self?.user = .failed(AppError.decodingError)
                    }
                }
            }
            .store(in: cancelBag)
    }

    private func setupLoginSubscription() {
        authenticationRepository.$isLoggedIn.sink { [weak self] isLoggedIn in
            self?.cancelBag.cancel()
            self?.user = .idle
            if isLoggedIn == true {
                self?.setupUserSubscriber()
            }
        }
        .store(in: loginCancelBag)
    }
}
