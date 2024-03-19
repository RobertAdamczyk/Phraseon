//
//  ToastView+Show.swift
//  Phraseon
//
//  Created by Robert Adamczyk on 19.03.24.
//

import Foundation

extension ToastView {

    public static func showError(message: String?) {
        guard let message else {
            showGeneralError()
            return
        }
        let toastToShow = ToastView(type: .error, message: message)
        displayOnScreen(toast: toastToShow)
    }

    public static func showSuccess(message: String) {
        let toastToShow = ToastView(type: .success, message: message)
        displayOnScreen(toast: toastToShow)
    }

    public static func showGeneralError() {
        let message = "An unexpected error occurred. Please try again later. If the problem persists, contact our support team."
        let toastToShow = ToastView(type: .error, message: message)
        displayOnScreen(toast: toastToShow)
    }
}
