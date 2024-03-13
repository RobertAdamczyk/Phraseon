//
//  ContentView.swift
//  Phraseon_InHouse_MacOS
//
//  Created by Robert Adamczyk on 12.03.24.
//

import SwiftUI

enum Tab {

    case home
    case user
}

struct ContentView: View {
    @State private var selectedTab: Tab = .home
    @State private var strings: [String] = []
    @State private var presented: Bool = false

    var body: some View {
        NavigationSplitView {
            VStack {
                Text("Menu")
                    .apply(.bold, size: .H1, color: .white)
                Button {
                    selectedTab = .home
                } label: {
                    Text("HOME")
                }
                Button {
                    selectedTab = .user
                } label: {
                    Text("USER")
                }
            }
        } detail: {
            NavigationStack(path: $strings) {
                Group {
                    switch selectedTab {
                    case .home: 
                        home
                    case .user:
                        Text("USER")
                    }
                }


            }
        }
    }

    @State private var searchText: String = ""

    private var home: some View {
        ScrollView {
            VStack {
                Button {
                    strings.append("ONLY TEST")
                } label: {
                    Text("PUSH")
                }
                ForEach(0..<100) { _ in
                    Rectangle()
                        .frame(height: 20)
                }
                Button {
                    presented.toggle()
                } label: {
                    Text("PRESENT")
                }
            }
            .scenePadding()
        }
        .searchable(text: $searchText)
        .navigationTitle("title")
        .navigationSubtitle("subtitle")
        .navigationDestination(for: String.self) { string in
            Text(string)
                .navigationTitle(string)
        }
    }
}

#Preview {
    ContentView()
}
