//
//  StandardInformationProtocol.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 15.01.24.
//

import Foundation

protocol StandardInformationProtocol {

    var title: String { get }
    var subtitle: String { get }

    func onUnderstoodTapped()
}
