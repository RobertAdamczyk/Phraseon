//
//  ProjectMembersView.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 06.01.24.
//

import SwiftUI

struct ProjectMembersView: View {

    @ObservedObject var viewModel: ProjectMembersViewModel

    var body: some View {
        ScrollView(showsIndicators: false) {

        }
        .navigationTitle("Members")
    }
}
