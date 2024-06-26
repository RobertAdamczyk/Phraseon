//
//  AppTextField.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 12.12.23.
//

import SwiftUI

struct AppTextField: View {

    var type: TType
    @Binding var text: String

    @State private var showPassword: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(type.title)
                .apply(.regular, size: .M, color: .white)
            makeTextField()
                .autocorrectionDisabled()
                #if os(iOS)
                .textInputAutocapitalization(.never)
                #endif
                .textFieldStyle(.plain)
                .padding(12)
                .background(makeBackground())
                .applyCellBackground()
        }
    }

    @ViewBuilder
    private func makeTextField() -> some View {
        HStack(spacing: 8) {

            switch type {
            case .email, .projectName, .keyId, .name, .surname, .keyContent:
                image
                TextField("", text: $text, 
                          prompt: Text(verbatim: type.placeholder)
                                    .foregroundStyle(appColor(.lightGray)),
                          axis: type.axis)
                    .apply(.medium, size: .L, color: .white)

            case .password, .confirmPassword, .currentPassword, .newPassword:
                image
                ZStack {
                    TextField("", text: $text, prompt: Text(verbatim: type.placeholder).foregroundStyle(appColor(.lightGray)))
                        .apply(.medium, size: .L, color: .white)
                        .opacity(showPassword ? 1 : 0)
                    SecureField("", text: $text, prompt: Text(verbatim: type.placeholder).foregroundStyle(appColor(.lightGray)))
                        .apply(.medium, size: .L, color: .white)
                        .opacity(showPassword ? 0 : 1)
                }
                Button(action: onShowPasswordTapped, label: {
                    Image(systemName: showPassword ? "eye.slash" : "eye")
                        .foregroundStyle(appColor(.white))
                })
            }
        }
    }

    private var image: some View {
        ZStack {
            type.imageView
        }
        .frame(width: 24)
    }

    private func makeBackground() -> some View {
        RoundedRectangle(cornerRadius: 8)
            .stroke(lineWidth: 2)
            .foregroundStyle(appColor(.lightGray))
    }

    private func onShowPasswordTapped() {
        showPassword.toggle()
    }
}

extension AppTextField {

    enum TType: Hashable {
        case email
        case password
        case confirmPassword
        case currentPassword
        case newPassword
        case projectName
        case keyId
        case name
        case surname
        case keyContent

        var title: String {
            return switch self {
            case .email: "Email"
            case .password: "Password"
            case .currentPassword: "Current Password"
            case .confirmPassword: "Confirm Password"
            case .newPassword: "New Password"
            case .projectName: "Project Name"
            case .keyId: "Phrase Identifier"
            case .name: "Name"
            case .surname: "Surname"
            case .keyContent: "Content"
            }
        }

        var placeholder: String {
            return switch self {
            case .email: "hallo@phraseon.com"
            case .password, .confirmPassword, .currentPassword, .newPassword: "Your password"
            case .projectName: "Your project name"
            case .keyId: "this_is_my_phrase"
            case .name: "John"
            case .surname: "Doe"
            case .keyContent: "Type your string phrase here..."
            }
        }

        var axis: Axis {
            return switch self {
            case .email, .password, .confirmPassword, .currentPassword, .name, .surname, .newPassword: .horizontal
            case .projectName, .keyId, .keyContent: .vertical
            }
        }

        var imageView: some View {
            switch self {
            case .email: Image(systemName: "envelope.fill").resizable().frame(width: 24, height: 16)
            case .password, .confirmPassword, .currentPassword, .newPassword: Image(systemName: "lock.fill").resizable().frame(width: 14, height: 20)
            case .projectName: Image(systemName: "folder.fill").resizable().frame(width: 20, height: 16)
            case .keyId: Image(systemName: "grid").resizable().frame(width: 16, height: 16)
            case .name, .surname: Image(systemName: "person.fill").resizable().frame(width: 16, height: 16)
            case .keyContent: Image(systemName: "pencil.and.list.clipboard").resizable().frame(width: 18, height: 20)
            }
        }
    }
}
