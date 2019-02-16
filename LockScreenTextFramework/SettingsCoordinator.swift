//
//  SettingsCoordinator.swift
//  LockScreenText
//
//  Created by Ben Staveley-Taylor on 09/11/2018.
//  Copyright © 2018 Ben Staveley-Taylor. All rights reserved.
//

import UIKit
import os.log
import Photos

// Actions that affect the view are sent using this delgate
protocol SettingsCoordinatorViewDelegate: AnyObject {

    func settingsDidChange(_ changes: SettingItems,
                           coordinator: SettingsCoordinatorProtocol,
                           animated: Bool)
}

// Identifies which setting is affected by an operation
struct SettingItems: OptionSet {
    let rawValue: Int

    static let imageBackgroundColor = SettingItems(rawValue: 1 << 0)    // 1
    static let imageBleedStyle      = SettingItems(rawValue: 1 << 1)    // 2
    static let scrollScale          = SettingItems(rawValue: 1 << 2)    // 4
    static let scrollOffset         = SettingItems(rawValue: 1 << 3)    // 8
    static let message              = SettingItems(rawValue: 1 << 4)    // 16
    static let textFont             = SettingItems(rawValue: 1 << 5)    // 32
    static let textColor            = SettingItems(rawValue: 1 << 6)    // 64
    static let boxColor             = SettingItems(rawValue: 1 << 7)    // 128
    static let boxBorderWidth       = SettingItems(rawValue: 1 << 8)    // 256
    static let boxCornerRadius      = SettingItems(rawValue: 1 << 9)    // 512
    static let boxYCentreOffset     = SettingItems(rawValue: 1 << 10)   // 1024
    static let image                = SettingItems(rawValue: 1 << 11)   // 2048

    // Cop-out with all bits set if we can't be sure what specifically changed
    static let all: SettingItems = [
        .imageBackgroundColor,
        .imageBleedStyle,
        .scrollScale,
        .scrollOffset,
        .message,
        .textFont,
        .textColor,
        .boxColor,
        .boxBorderWidth,
        .boxCornerRadius,
        .boxYCentreOffset,
        .image
    ]
}

protocol SettingsCoordinatorProtocol {

    // Simple Model (i.e. Settings) accessors
    var imageBackgroundColor: UIColor { get set }
    var imageBleedStyle: BleedStyle { get set }
    var scrollScale: CGFloat { get set }
    var scrollOffset: CGPoint { get set }
    var message: String { get set }
    var textFont: UIFont { get set }
    var textColor: UIColor { get set }
    var boxColor: UIColor { get set }
    var boxBorderWidth: CGFloat { get set }
    var boxCornerRadius: CGFloat { get set }
    var boxYCentreOffset: CGFloat { get set }

    // Store an image as the current working selection
    // This will be nil if a plain background colour is selected
    var image: UIImage? { get set }

    func saveToPhotos(image: UIImage)

    // Normally, when any of the model accessors are used to change a value, the
    // values are persisted and observers are notified. If making multiple
    // changes then call startBatchChanges() before, and then at the end
    // endBatchChanges() will do a single persist-and-update.
    func startBatchChanges()
    func endBatchChanges()

    // Set everything to factory defaults
    func reset()
}

class SettingsCoordinator: NSObject {

    private weak var delegate: SettingsCoordinatorViewDelegate?
    private var settings: Settings {
        didSet {
            // Clear any caches
            self.cachedImage = nil
        }
    }

    private var cachedImage: UIImage?
    
    private var inBatchMode = false
    private var batchedChanges: SettingItems = []

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
    private func settingsDidChange(_ changes: SettingItems) {
        // Ignore (but collect) when in batch mode
        if self.inBatchMode {
            self.batchedChanges = self.batchedChanges.union(changes)
        }
        else {
            self.delegate?.settingsDidChange(changes, coordinator: self, animated: true)
            try? self.settings.writeToUserDefaults()
        }
    }

    @objc
    func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: Any?) {

        if let error = error {
            os_log("Error saving image to Photos (%@)", "\(error)")

            AlertUtilities.showMessage(title: Resources.localizedString("FailedAlertTitle"),
                                       body: error.localizedDescription)
        } else {
            AlertUtilities.showMessage(title: Resources.localizedString("SavedAlertTitle"),
                                       body: Resources.localizedString("HowToSetWallpaperBody"),
                                       button1Text: Resources.localizedString("OpenSettings"),
                                       button2Text: Resources.localizedString("Done")) { choice in

                                        if choice == 1 {
                                            // Open Settings
                                            SystemSettingsUtilities.openSettings()
                                        }
            }
        }
    }

}

extension SettingsCoordinator: SettingsCoordinatorProtocol {

    // Model (i.e. Settings) accessors
    var imageBackgroundColor: UIColor {
        get {
            return self.settings.imageBackgroundColor
        }
        set {
            self.settings.imageBackgroundColor = newValue
            self.settingsDidChange([.imageBackgroundColor])
        }
    }

    var imageBleedStyle: BleedStyle {
        get {
            return self.settings.imageBleedStyle
        }
        set {
            self.settings.imageBleedStyle = newValue
            self.settingsDidChange([.imageBleedStyle])
        }
    }

    var scrollScale: CGFloat {
        get {
            return self.settings.scrollScale
        }
        set {
            self.settings.scrollScale = newValue
            self.settingsDidChange([.scrollScale])
        }
    }

    var scrollOffset: CGPoint {
        get {
            return self.settings.scrollOffset
        }
        set {
            self.settings.scrollOffset = newValue
            self.settingsDidChange([.scrollOffset])
        }
    }

    var message: String {
        get {
            return self.settings.message
        }
        set {
            self.settings.message = newValue
            self.settingsDidChange([.message])
        }
    }

    var textFont: UIFont {
        get {
            return self.settings.textFont
        }
        set {
            self.settings.textFont = newValue
            self.settingsDidChange([.textFont])
        }
    }

    var textColor: UIColor {
        get {
            return self.settings.textColor
        }
        set {
            self.settings.textColor = newValue
            self.settingsDidChange([.textColor])
        }
    }

    var boxColor: UIColor {
        get {
            return self.settings.boxColor
        }
        set {
            self.settings.boxColor = newValue
            self.settingsDidChange([.boxColor])
        }
    }

    var boxBorderWidth: CGFloat {
        get {
            return self.settings.boxBorderWidth
        }
        set {
            self.settings.boxBorderWidth = newValue
            self.settingsDidChange([.boxBorderWidth])
        }
    }

    var boxCornerRadius: CGFloat {
        get {
            return self.settings.boxCornerRadius
        }
        set {
            self.settings.boxCornerRadius = newValue
            self.settingsDidChange([.boxCornerRadius])
        }
    }

    var boxYCentreOffset: CGFloat {
        get {
            return settings.boxYCentreOffset
        }
        set {
            self.settings.boxYCentreOffset = newValue
            self.settingsDidChange([.boxYCentreOffset])
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

            self.settingsDidChange([.image])
        }
    }

    func saveToPhotos(image: UIImage) {

        // Check we have access to the Photos data
        PHPhotoLibrary.requestAuthorization { status in
            
            if status == .authorized {

                // Save the renderable view into the photo album then tell the user
                // what to do in the completion callback
                UIImageWriteToSavedPhotosAlbum(image,
                                               self,
                                               #selector(self.image(_:didFinishSavingWithError:contextInfo:)),
                                               nil)
            }
            else {
                AlertUtilities.showMessage(title: Resources.localizedString("FailedAlertTitle"),
                                           body: Resources.localizedString("PhotosAccessDenied"),
                                           button1Text: Resources.localizedString("OpenSettings"),
                                           button2Text: Resources.localizedString("Done")) { choice in

                                            if choice == 1 {
                                                // Open Settings
                                                SystemSettingsUtilities.openSettings()
                                            }
                }
            }
        }
    }

    func startBatchChanges() {
        self.inBatchMode = true
        self.batchedChanges = []
    }

    func endBatchChanges() {
        self.inBatchMode = false
        self.settingsDidChange(self.batchedChanges)
    }

    func reset() {
        self.settings = Settings.defaults
        self.settingsDidChange(SettingItems.all)
    }
}
