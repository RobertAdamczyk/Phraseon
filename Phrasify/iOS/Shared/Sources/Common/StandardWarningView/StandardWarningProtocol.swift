//
//  StandardWarningProtocol.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 15.01.24.
//

import Foundation

protocol StandardWarningProtocol: ObservableObject {

    var isLoading: Bool { get set }

    var title: String { get }
    var subtitle: String { get }
    var buttonText: String { get }

    func onPrimaryButtonTapped() async
    func onCancelTapped()
}
