//
//  ToastView+Show.swift
//  Phraseon_InHouse_MacOS
//
//  Created by Robert Adamczyk on 19.03.24.
//

import SwiftUI

extension ToastView {

    static func displayOnScreen(toast: ToastView) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { // Workaround to fix show toast after sheet dismiss.
            guard let main = NSApplication.shared.keyWindow, let contentView = main.contentView else { return }

            let toastController = NSHostingController(rootView: toast)
            toastController.view.frame = contentView.bounds
            contentView.addSubview(toastController.view)

            DispatchQueue.main.asyncAfter(deadline: .now() + ToastView.toastDuration + 1) {
                toastController.view.removeFromSuperview()
            }
        }

    }
}
