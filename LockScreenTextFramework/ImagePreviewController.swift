//
//  ImagePreviewController.swift
//  LockScreenText
//
//  Created by Ben Staveley-Taylor on 06/11/2018.
//  Copyright © 2018 Ben Staveley-Taylor. All rights reserved.
//

import UIKit
import MobileCoreServices
import os.log
import EFColorPicker

@objc
public class ImagePreviewController: UIViewController {

    // Nib properties

    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var textBoxView: UIView!
    @IBOutlet private weak var helpButton: UIBarButtonItem!
    @IBOutlet private weak var choosePhotoButton: UIBarButtonItem!
    @IBOutlet private weak var plainColourButton: UIBarButtonItem!
    @IBOutlet private weak var saveButton: UIBarButtonItem!
    @IBOutlet private weak var bleedStyleSegmentControl: UISegmentedControl!
    @IBOutlet private var imageTapRecognizer: UITapGestureRecognizer!
    @IBOutlet private var textTapRecognizer: UITapGestureRecognizer!

    // Render this view to get the lock screen image
    @IBOutlet private weak var renderableView: UIView!
    @IBOutlet private weak var renderableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var renderableViewWidthConstraint: NSLayoutConstraint!
    
    // Local properties
    private var settingsCoordinator: SettingsCoordinatorProtocol!

    // true if the controls are all hidden to show the whole view
    var isInPreviewMode = false

    public override func viewDidLoad() {
        super.viewDidLoad()

        self.title = NSLocalizedString("ProductTitle", comment: "")
        self.helpButton.title = NSLocalizedString("HelpButtonText", comment: "")

        self.bleedStyleSegmentControl.setTitle(NSLocalizedString("StillBleedStyle", comment: ""),
                                               forSegmentAt: BleedStyle.still.rawValue)
        self.bleedStyleSegmentControl.setTitle(NSLocalizedString("PerspectiveBleedStyle", comment: ""),
                                               forSegmentAt: BleedStyle.perspective.rawValue)
        self.bleedStyleSegmentControl.layer.cornerRadius = 4
        self.bleedStyleSegmentControl.layer.masksToBounds = true

        self.settingsCoordinator = SettingsCoordinator(withDelegate: self)
        self.settingsDidChange(coordinator: self.settingsCoordinator, animated: false)
    }

    @IBAction private func onHelpTapped(_ sender: Any) {
    }

    @IBAction private func onChoosePhotoTapped(_ sender: Any) {

        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.mediaTypes = [kUTTypeImage as String]        // Still images only
        picker.delegate = self

        // We'll have to do our own cropping -- what you get back from
        // UIImagePickerController is relatively low resolution
        picker.allowsEditing = false

        self.present(picker, animated: true)
    }

    @IBAction private func onPlainColourTapped(_ sender: Any) {
    }

    @IBAction private func onSaveTapped(_ sender: Any) {

        // Save the renderable view into the photo album
        let image = ImageUtilities.imageFromView(self.renderableView)
        self.settingsCoordinator.saveToPhotos(image: image)
    }

    // When the image area is tapped, toggle the chrome off so the whole thing can be seen
    // Another tap toggles it back on again
    @IBAction private func onImageTapped(_ sender: Any) {
        self.togglePreviewMode()
        return
    }

    // Open the text attributes controller
    @IBAction private func onTextTapped(_ sender: Any) {
        return
    }

    // Segmented control changed from still to perspective
    @IBAction private func onBleedStyleChanged(_ sender: Any) {

        if let bleedStyle = BleedStyle(rawValue: self.bleedStyleSegmentControl.selectedSegmentIndex) {
            self.settingsCoordinator.imageBleedStyle = bleedStyle
        }
    }

    // MARK: Private methods

    private func togglePreviewMode() {

        self.isInPreviewMode.toggle()

        self.bleedStyleSegmentControl.isHidden = self.isInPreviewMode

        self.navigationController?.setNavigationBarHidden(self.isInPreviewMode, animated: true)
        self.navigationController?.setToolbarHidden(self.isInPreviewMode, animated: true)

        // Can't push new VCs when the Navigation Bar is hidden, so disallow text editing
        self.textTapRecognizer.isEnabled = !self.isInPreviewMode
    }

    private func setBleedStyle(_ bleedStyle: BleedStyle, animated: Bool) {
        // When in perspective mode the image needs to bleed off the visible
        // area by 25 points all round to have material to work with when tilting

        let bleed: CGFloat
        switch bleedStyle {
        case .still:
            bleed = 0

        case .perspective:
            bleed = 25
        }

        let duration: TimeInterval = animated ? Constants.defaultAnimationDuration : 0
        UIView.animate(withDuration: duration) {
            self.renderableViewHeightConstraint.constant = 2 * bleed
            self.renderableViewWidthConstraint.constant = 2 * bleed
            self.view.layoutIfNeeded()
        }
    }

}

extension ImagePreviewController: UIImagePickerControllerDelegate {

    private func imagePickerController(_ picker: UIImagePickerController,
                                       didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {

        // info[.editedImage] should be what we want, but it is very low quality
        // I'll have to implement scale and crop at some point

        guard let originalImage = info[.originalImage] as? UIImage else {
            return
        }

        self.settingsCoordinator.image = originalImage

        self.dismiss(animated: true)
    }
}

// Required by UIImagePickerController
extension ImagePreviewController: UINavigationControllerDelegate {}

extension ImagePreviewController: SettingsCoordinatorViewDelegate {

    func settingsDidChange(coordinator: SettingsCoordinatorProtocol, animated: Bool) {

        // Update the UI to show the new settings

        // image will be nil if this is a plain colour
        self.imageView.image = coordinator.image
        self.imageView.backgroundColor = coordinator.imageBackgroundColour

        self.bleedStyleSegmentControl.selectedSegmentIndex = coordinator.imageBleedStyle.rawValue
        self.setBleedStyle(coordinator.imageBleedStyle, animated: animated)

        self.textLabel.text = coordinator.message
        self.textLabel.textColor = coordinator.textColour

        self.textBoxView.layer.backgroundColor = coordinator.boxColour.cgColor
        self.textBoxView.layer.borderWidth = coordinator.boxBorderWidth
        self.textBoxView.layer.cornerRadius = coordinator.boxCornerRadius
    }
}

extension ImagePreviewController: EFColorSelectionViewControllerDelegate {

    @objc
    public func colorViewController(_ colorViewCntroller: EFColorSelectionViewController, didChangeColor color: UIColor) {
        // ...
    }

}
