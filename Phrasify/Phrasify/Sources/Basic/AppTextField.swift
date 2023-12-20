//
//  AppTextField.swift
//  Phrasify
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
        }
    }

    @ViewBuilder
    private func makeTextField() -> some View {
        switch type {
        case .email, .projectName:
            TextField("", text: $text, prompt: Text(verbatim: type.placeholder).foregroundStyle(appColor(.darkGray)))
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .apply(.medium, size: .L, color: .white)
                .padding(8)
                .background(makeBackground())
        case .password, .confirmPassword:
            HStack(spacing: 4) {
                ZStack {
                    TextField("", text: $text, prompt: Text(verbatim: type.placeholder).foregroundStyle(appColor(.darkGray)))
                        .apply(.medium, size: .L, color: .white)
                        .opacity(showPassword ? 1 : 0)
                    SecureField("", text: $text, prompt: Text(verbatim: type.placeholder).foregroundStyle(appColor(.darkGray)))
                        .apply(.medium, size: .L, color: .white)
                        .opacity(showPassword ? 0 : 1)
                }
                Button(action: onShowPasswordTapped, label: {
                    Image(systemName: showPassword ? "eye.slash" : "eye")
                        .foregroundStyle(appColor(.white))
                })
            }
            .padding(8)
            .background(makeBackground())
        }
    }

    private func makeBackground() -> some View {
        RoundedRectangle(cornerRadius: 8)
            .stroke(lineWidth: 1)
            .foregroundStyle(appColor(.darkGray))
    }

    private func onShowPasswordTapped() {
        showPassword.toggle()
    }
}

extension AppTextField {

    enum TType {
        case email
        case password
        case confirmPassword
        case projectName

        var title: String {
            return switch self {
            case .email: "Email"
            case .password: "Password"
            case .confirmPassword: "Confirm Password"
            case .projectName: "Project Name"
            }
        }

        var placeholder: String {
            return switch self {
            case .email: "hallo@phrasify.com"
            case .password, .confirmPassword: "Your password"
            case .projectName: "Your project name"
            }
        }
    }
}
