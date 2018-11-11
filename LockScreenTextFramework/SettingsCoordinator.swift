//
//  SettingsCoordinator.swift
//  LockScreenText
//
//  Created by Ben Staveley-Taylor on 09/11/2018.
//  Copyright © 2018 Ben Staveley-Taylor. All rights reserved.
//

import UIKit
import os.log

// Actions that affect the view are sent using this delgate
protocol SettingsCoordinatorViewDelegate: AnyObject {

    func settingsDidChange(coordinator: SettingsCoordinatorProtocol, animated: Bool)
}

protocol SettingsCoordinatorProtocol {

    // Simple Model (i.e. Settings) accessors
    var imageBackgroundColour: UIColor { get set }
    var imageBleedStyle: BleedStyle { get set }
    var message: String { get set }
    var textFont: UIFont { get set }
    var textColour: UIColor { get set }
    var boxColour: UIColor { get set }
    var boxBorderWidth: CGFloat { get set }
    var boxCornerRadius: CGFloat { get set }

    // Store an image as the current working selection
    // This will be nil if a plain background colour is selected
    var image: UIImage? { get set }

    func saveToPhotos(image: UIImage)
}

class SettingsCoordinator {

    private weak var delegate: SettingsCoordinatorViewDelegate?
    private var settings: Settings

    private var cachedImage: UIImage?

    init(withDelegate delegate: SettingsCoordinatorViewDelegate, settings: Settings? = nil) {

        self.delegate = delegate

        // If explicit settings were passed in, use them
        if let settings = settings {
            self.settings = settings
        } else {
            // Default behaviour is to restore from saved storage
            // If any error occurs, use defaults
            self.settings = Settings.readFromUserDefaults() ?? Settings.defaults
        }
    }

    // To do after any write to settings
    private func settingsDidChange() {
        self.delegate?.settingsDidChange(coordinator: self, animated: true)
        try? self.settings.writeToUserDefaults()
    }

    @objc
    func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: Any?) {

        let title: String
        let body: String

        if let error = error {
            os_log("Error saving image to Photos (%@)", "\(error)")

            title = NSLocalizedString("FailedAlertTitle", comment: "")
            body = error.localizedDescription
        } else {
            title = NSLocalizedString("SavedAlertTitle", comment: "")
            body = NSLocalizedString("HowToSetWallpaperBody", comment: "")
        }

        AlertUtilities.showMessage(title: title, body: body)
    }

}

extension SettingsCoordinator: SettingsCoordinatorProtocol {

    // Model (i.e. Settings) accessors
    var imageBackgroundColour: UIColor {
        get {
            return self.settings.imageBackgroundColour
        }
        set {
            self.settings.imageBackgroundColour = newValue
            self.settingsDidChange()
        }
    }

    var imageBleedStyle: BleedStyle {
        get {
            return self.settings.imageBleedStyle
        }
        set {
            self.settings.imageBleedStyle = newValue
            self.settingsDidChange()
        }
    }

    var message: String {
        get {
            return self.settings.message
        }
        set {
            self.settings.message = newValue
            self.settingsDidChange()
        }
    }

    var textFont: UIFont {
        get {
            return self.settings.textFont
        }
        set {
            self.settings.textFont = newValue
            self.settingsDidChange()
        }
    }

    var textColour: UIColor {
        get {
            return self.settings.textColour
        }
        set {
            self.settings.textColour = newValue
            self.settingsDidChange()
        }
    }

    var boxColour: UIColor {
        get {
            return self.settings.boxColour
        }
        set {
            self.settings.boxColour = newValue
            self.settingsDidChange()
        }
    }

    var boxBorderWidth: CGFloat {
        get {
            return self.settings.boxBorderWidth
        }
        set {
            self.settings.boxBorderWidth = newValue
            self.settingsDidChange()
        }
    }

    var boxCornerRadius: CGFloat {
        get {
            return self.settings.boxCornerRadius
        }
        set {
            self.settings.boxCornerRadius = newValue
            self.settingsDidChange()
        }
    }

    var image: UIImage? {
        get {
            // If we have a cached image, return it. If not, read it from disk by name.
            if self.cachedImage == nil {
                if let imageName = self.settings.imageName {
                    self.cachedImage = ImageUtilities.readSavedJpegImage(nameWithoutExtension: imageName)
                }
            }

            // This may still return nil
            return self.cachedImage
        }
        set {
            self.cachedImage = newValue

            if let image = newValue {
                // Save the image as a JPEG so we can get it back after relaunch
                let savedUrl = ImageUtilities.saveAsJpeg(image: image, nameWithoutExtension: "LastPickedImage")
                self.settings.imageName = savedUrl?.lastPathComponent
            } else {
                // No image: plain background colour
                self.settings.imageName = nil
            }

            self.settingsDidChange()
        }
    }

    func saveToPhotos(image: UIImage) {
        
        // Save the renderable view into the photo album then tell the user
        // what to do in the completion callback
        UIImageWriteToSavedPhotosAlbum(image,
                                       self,
                                       #selector(image(_:didFinishSavingWithError:contextInfo:)),
                                       nil)
    }

}
