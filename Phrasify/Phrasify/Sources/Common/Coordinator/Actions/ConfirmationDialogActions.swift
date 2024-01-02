//
//  ConfirmationDialogActions.swift
//  Phrasify
//
//  Created by Robert Adamczyk on 02.01.24.
//

import Foundation

protocol ConfirmationDialogActions: AnyObject {

    func showUploadPhotoDialog(galleryAction: @escaping () -> Void)
}
