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

@objc
class ImagePreviewController: UIViewController {

    // Nib properties

    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var textBoxView: UIView!
    @IBOutlet private weak var helpButton: UIBarButtonItem!
    @IBOutlet private weak var choosePhotoButton: UIBarButtonItem!
    @IBOutlet private weak var plainColorButton: UIBarButtonItem!
    @IBOutlet private weak var saveButton: UIBarButtonItem!
    @IBOutlet private weak var bleedStyleSegmentControl: UISegmentedControl!
    @IBOutlet private var imageTapRecognizer: UITapGestureRecognizer!
    @IBOutlet private var textBoxTapRecognizer: UITapGestureRecognizer!
    @IBOutlet private var textBoxPanRecognizer: UIPanGestureRecognizer!
    @IBOutlet private weak var textLabelCentreYConstraint: NSLayoutConstraint!

    // Render this view to get the lock screen image
    @IBOutlet private weak var renderableView: UIView!
    @IBOutlet private weak var renderableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var renderableViewWidthConstraint: NSLayoutConstraint!
    
    // Local properties
    private var settingsCoordinator: SettingsCoordinatorProtocol!

    // true if the controls are all hidden to show the whole view
    var isInPreviewMode = false

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = Resources.localizedString("ProductTitle")
        self.helpButton.title = Resources.localizedString("HelpButtonText")

        self.bleedStyleSegmentControl.setTitle(Resources.localizedString("StillBleedStyle"),
                                               forSegmentAt: BleedStyle.still.rawValue)
        self.bleedStyleSegmentControl.setTitle(Resources.localizedString("PerspectiveBleedStyle"),
                                               forSegmentAt: BleedStyle.perspective.rawValue)
        self.bleedStyleSegmentControl.layer.cornerRadius = 4
        self.bleedStyleSegmentControl.layer.masksToBounds = true

        self.settingsCoordinator = SettingsCoordinator(withDelegate: self)
        self.settingsDidChange(coordinator: self.settingsCoordinator, animated: false)
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

    // Show the ColorPicker
    @IBAction private func onPlainColorTapped(_ sender: Any) {

        let colorPickerVC = ColorPickerViewController(startingColor: self.settingsCoordinator.imageBackgroundColor,
                                                      delegate: self)

        // Present as a popover on iPad, or push on iPhone

        if self.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClass.compact {

            // iPhone-style, including iPads in narrow split-screen view.
            self.navigationController?.pushViewController(colorPickerVC, animated: true)
        } else {

            // iPad-style
            colorPickerVC.modalPresentationStyle = .popover
            self.present(colorPickerVC, animated: true, completion: nil)

            let popController = colorPickerVC.popoverPresentationController
            popController?.backgroundColor = colorPickerVC.view.backgroundColor
            popController?.permittedArrowDirections = .any
            popController?.barButtonItem = sender as? UIBarButtonItem
            popController?.delegate = self
        }
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

    // Segmented control changed from still to perspective
    @IBAction private func onBleedStyleChanged(_ sender: Any) {

        if let bleedStyle = BleedStyle(rawValue: self.bleedStyleSegmentControl.selectedSegmentIndex) {
            self.settingsCoordinator.imageBleedStyle = bleedStyle
        }
    }

    // User is dragging the text box.
    // It is always centred horizontally
    @IBAction private func onTextBoxPan(_ sender: UIPanGestureRecognizer) {

        switch sender.state {
        case .changed:
            // Do the drag

            // Where are we, wrt the image bounding box
            if sender.numberOfTouches > 0 {
                let touchPos = sender.location(ofTouch: 0, in: self.imageView)

                var touchY = touchPos.y

                // Can't drag textBox out of the imageview
                let textBoxHeight = self.textBoxView.bounds.height
                let permittedRect = self.imageView.bounds.insetBy(dx: 0, dy: textBoxHeight/2)

                touchY = max(touchY, permittedRect.minY)
                touchY = min(touchY, permittedRect.maxY)

                // Update the layout constraint of the text label to put it at this
                // location. It is a vertical centre + deltaY constraint.

                var deltaY = touchY - self.imageView.bounds.height/2

                // If we are near the vertical centre, snap to it
                if abs(deltaY) < 20 {
                    deltaY = 0
                }
                self.textLabelCentreYConstraint.constant = deltaY
                self.imageView.layoutIfNeeded()
            }

        case .ended:
            // Save the final value
            self.settingsCoordinator.boxYCentreOffset = self.textLabelCentreYConstraint.constant

        default:
            break
        }
    }

    // MARK: Private methods

    private func togglePreviewMode() {

        self.isInPreviewMode.toggle()

        self.bleedStyleSegmentControl.isHidden = self.isInPreviewMode

        self.navigationController?.setNavigationBarHidden(self.isInPreviewMode, animated: true)
        self.navigationController?.setToolbarHidden(self.isInPreviewMode, animated: true)

        // Can't push new VCs when the Navigation Bar is hidden, so disallow text editing
        self.textBoxTapRecognizer.isEnabled = !self.isInPreviewMode
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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        switch segue.identifier {

        case "editTextAttributesSegue":
            self.prepareForEditTextAttributesSegue(segue, sender: sender)

        case "showHelpSegue":
            self.prepareForShowHelpSegue(segue, sender: sender)

        default:
            os_log("Unexpected segue: %@", segue.identifier ?? "<nil>")
        }
    }

    private func prepareForEditTextAttributesSegue(_ segue: UIStoryboardSegue, sender: Any?) {
        
        assert(segue.identifier == "editTextAttributesSegue")

        guard let destVC = segue.destination as? TextAttributesViewController else {
            assertionFailure("destination of editTextAttributesSegue was not a TextAttributesViewController")
            return
        }

        destVC.prepare(settingsCoordinator: self.settingsCoordinator)
    }

    private func prepareForShowHelpSegue(_ segue: UIStoryboardSegue, sender: Any?) {

        assert(segue.identifier == "showHelpSegue")

        guard let helpNav = segue.destination as? UINavigationController else {
            assertionFailure("destination of showHelpSegue was not a UINavigationController")
            return
        }

        guard let helpPageController = helpNav.topViewController as? HelpPageViewController else {
            assertionFailure("top view controller was not a HelpPageViewController")
            return
        }

        helpPageController.preparePages()

        let aboutVC = AboutViewController.create()
        helpPageController.appendPage(aboutVC)
    }

    // After many colour update notifications while the selection UI is up,
    // accept the final value and persist it
    private func persistImageBackgroundColor() {

        if let backgroundColor = self.imageView.backgroundColor {
            self.settingsCoordinator.startBatchChanges()
            
            self.settingsCoordinator.imageBackgroundColor = backgroundColor

            // Remove any image so the background colour shows
            self.settingsCoordinator.image = nil

            self.settingsCoordinator.endBatchChanges()
        }
    }
}

extension ImagePreviewController: UIImagePickerControllerDelegate {

    @objc
    public func imagePickerController(_ picker: UIImagePickerController,
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
        self.imageView.backgroundColor = coordinator.imageBackgroundColor

        self.bleedStyleSegmentControl.selectedSegmentIndex = coordinator.imageBleedStyle.rawValue
        self.setBleedStyle(coordinator.imageBleedStyle, animated: animated)

        // If the string is empty, show a helpful prompt
        var message = coordinator.message
        if message.isEmpty {
            message = Resources.localizedString("MessagePromptText")
        }
        self.textLabel.text = message

        self.textLabel.textColor = coordinator.textColor
        self.textLabel.font = coordinator.textFont

        self.textBoxView.layer.backgroundColor = coordinator.boxColor.cgColor
        self.textBoxView.layer.borderWidth = coordinator.boxBorderWidth
        self.textBoxView.layer.cornerRadius = coordinator.boxCornerRadius

        self.textLabelCentreYConstraint.constant = coordinator.boxYCentreOffset
    }
}

extension ImagePreviewController: ColorPickerViewControllerDelegate {

    func colorPicker(_ picker: ColorPickerViewController, didChangeTo color: UIColor) {
        self.imageView.backgroundColor = color
    }

    func colorPickerWillClose(_ picker: ColorPickerViewController) {
        self.persistImageBackgroundColor()

        // This is only called if we presented by pushing, so:
        self.navigationController?.popViewController(animated: true)
    }
}

extension ImagePreviewController: UIPopoverPresentationControllerDelegate {

    // Detect closure of the Colour Picker and save the final result
    @objc
    public func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        self.persistImageBackgroundColor()
    }
}
