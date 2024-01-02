//
//  ConfirmationDialog.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 02.01.24.
//

import SwiftUI

struct ConfirmationDialog: ViewModifier {

    @Binding var item: ConfirmationDialog.Model?

    @State private var showDialog: Bool = false

    init(item: Binding<ConfirmationDialog.Model?>) {
        self._item = item
        self.showDialog = item.wrappedValue != nil
        setupColorScheme()
    }

    func body(content: Content) -> some View {
        makeContent(content: content)
            .onChange(of: item) { _, newValue in
                showDialog = newValue != nil
            }
            .onChange(of: showDialog) { _, newValue in
                if !newValue {
                    item = nil
                }
            }
    }

    @ViewBuilder
    private func makeContent(content: Content) -> some View {
        if UIScreen.main.traitCollection.userInterfaceIdiom == .pad {
            content
                .alert(item?.title ?? "", isPresented: $showDialog, actions: {
                    makeBody()
                    SwiftUI.Button("Cancel", role: .cancel) { }
                })
        } else {
            content
                .confirmationDialog("", isPresented: $showDialog) {
                    makeBody()
                }
        }
    }

    @ViewBuilder
    private func makeBody() -> some View {
        switch item {
        case .selectImage(let actionGallery):
            SwiftUI.Button("Choose from Gallery", action: actionGallery)
        default:
            EmptyView()
        }
    }

    private func setupColorScheme() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        windowScene.keyWindow?.overrideUserInterfaceStyle = .dark
    }
}

extension ConfirmationDialog {

    enum Model: Equatable {

        case selectImage(() -> Void)

        var title: String {
            switch self {
            case .selectImage: return "Upload a photo"
            }
        }

        static func == (lhs: ConfirmationDialog.Model, rhs: ConfirmationDialog.Model) -> Bool {
            switch (lhs, rhs) {
            case (.selectImage, .selectImage): return true
            }
        }
    }
}

extension View {
    func confirmationDialog(item: Binding<ConfirmationDialog.Model?>) -> some View {
        modifier(ConfirmationDialog(item: item))
    }
}
