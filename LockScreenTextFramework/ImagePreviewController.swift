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

    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var textBoxView: UIView!
    @IBOutlet private weak var helpButton: UIBarButtonItem!
    @IBOutlet private weak var choosePhotoButton: UIBarButtonItem!
    @IBOutlet private weak var plainColorButton: UIBarButtonItem!
    @IBOutlet private weak var textAttributesButton: UIBarButtonItem!
    @IBOutlet private weak var saveButton: UIBarButtonItem!
    @IBOutlet private var imageTapRecognizer: UITapGestureRecognizer!
    @IBOutlet private var imageDoubleTapRecognizer: UITapGestureRecognizer!
    @IBOutlet private var textBoxTapRecognizer: UITapGestureRecognizer!
    @IBOutlet private var textBoxPanRecognizer: UIPanGestureRecognizer!
    @IBOutlet private weak var textLabelCentreYConstraint: NSLayoutConstraint!

    // Render this view to get the lock screen image
    @IBOutlet private weak var renderableView: UIView!
    @IBOutlet private weak var renderableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var renderableViewWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet private weak var imageViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet private weak var imageViewHeightConstraint: NSLayoutConstraint!

    // Local properties
    private var settingsCoordinator: SettingsCoordinatorProtocol!
    private var colorDidChange: Bool = false
    private var lastPanTouchPos: CGPoint = .zero

    // true if the controls are all hidden to show the whole view
    var isInPreviewMode = false

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = Resources.sharedInstance.appName
        self.helpButton.title = Resources.sharedInstance.localizedString("HelpButtonText")

        self.settingsCoordinator = SettingsCoordinator(withDelegate: self)
        self.settingsDidChange(.all, coordinator: self.settingsCoordinator, animated: false)
        
        // Necessary to allow both single and double-tap recognizers
        self.imageTapRecognizer.require(toFail: self.imageDoubleTapRecognizer)
        self.imageTapRecognizer.delegate = self
        self.imageDoubleTapRecognizer.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Make sure our toolbar is visible
        self.navigationController?.setToolbarHidden(false, animated: false)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        self.configureImageViewSize()
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

        let colorPickerVC = ColorPickerViewController(title: Resources.sharedInstance.localizedString("PickBackgroundColorTitle"),
                                                      startingColor: self.settingsCoordinator.imageBackgroundColor,
                                                      allowTransparency: false,
                                                      delegate: self)

        // Present as a popover on iPad, or push on iPhone
        self.colorDidChange = false

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

    @IBAction private func onTextAttributesTapped(_ sender: Any) {
        // Same as tapping the text label, but more discoverable
        // Might be handy if the text label text goes tiny

        self.performSegue(withIdentifier: "editTextAttributesSegue", sender: self)
    }

    @IBAction private func onSaveTapped(_ sender: Any) {

        // Save the renderable view into the photo album
        let image = ImageUtilities.imageFromView(self.renderableView)
        self.settingsCoordinator.saveToPhotos(image: image, fromViewController: self)
    }

    // When the image area is tapped, toggle the chrome off so the whole thing can be seen
    // Another tap toggles it back on again
    @IBAction private func onImageTapped(_ sender: Any) {
        self.togglePreviewMode()
    }

    // Double-tap removes any scroll and zoom, i.e. back to initial state
    @IBAction private func onImageDoubleTapped(_ sender: Any) {
        self.setImageToDefaultPosition()
    }

    // User is dragging the text box.
    // It is always centred horizontally
    @IBAction private func onTextBoxPan(_ sender: UIPanGestureRecognizer) {

        switch sender.state {
        case .began:
            // Remember where the drag started
            guard sender.numberOfTouches > 0 else {
                return
            }
            self.lastPanTouchPos = sender.location(ofTouch: 0, in: self.renderableView)

        case .changed:
            // Do the drag

            guard sender.numberOfTouches > 0 else {
                return
            }

            // Where are we, wrt the image bounding box
            let curTouchPos = sender.location(ofTouch: 0, in: self.renderableView)
            var touchY = curTouchPos.y

            // Can't drag textBox out of the renderableView
            let textBoxHeight = self.textBoxView.bounds.height
            let permittedRect = self.renderableView.bounds.insetBy(dx: 0, dy: textBoxHeight/2)

            touchY = max(touchY, permittedRect.minY)
            touchY = min(touchY, permittedRect.maxY)

            let boundedTouchPos = CGPoint(x: curTouchPos.x, y: touchY)

            // Update the layout constraint of the text label to put it at this
            // location. It is a vertical centre + deltaY constraint.
            let deltaY = touchY-self.lastPanTouchPos.y
            self.lastPanTouchPos = boundedTouchPos

            if deltaY != 0 {
                self.textLabelCentreYConstraint.constant += deltaY
                self.renderableView.layoutIfNeeded()
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

        guard let helpPageViewController = helpNav.topViewController as? HelpPageViewController else {
            assertionFailure("top view controller was not a HelpPageViewController")
            return
        }

        // sender may be specifed as a "HelpPage" type giving a page to open at
        if let initialPage = sender as? HelpPage {
            helpPageViewController.preparePages(startingAt: initialPage.rawValue)
        }
        else {
            helpPageViewController.preparePages()
        }

        let aboutVC = AboutViewController.create()
        helpPageViewController.appendPage(aboutVC)
    }

    public func showHelp(startingAt page: HelpPage) {
        self.performSegue(withIdentifier: "showHelpSegue", sender: page)
    }

    // After many colour update notifications while the selection UI is up,
    // accept the final value and persist it
    private func persistImageBackgroundColor() {

        if let backgroundColor = self.imageView.backgroundColor {
            self.settingsCoordinator.startBatchChanges()
            
            self.settingsCoordinator.imageBackgroundColor = backgroundColor

            // Remove any image so the background colour shows
            self.settingsCoordinator.image = nil
            self.settingsCoordinator.scrollOffset = .zero
            self.settingsCoordinator.scrollScale = 1.0

            self.settingsCoordinator.endBatchChanges()
        }
    }
}

extension ImagePreviewController: UIImagePickerControllerDelegate {

    @objc
    public func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {

        // info[.editedImage] should be what we want, but it is very low quality
        // We have to implement our own scaling and cropping

        guard let originalImage = info[.originalImage] as? UIImage else {
            return
        }

        self.settingsCoordinator.image = originalImage
        
        self.setImageToDefaultPosition()

        self.dismiss(animated: true)
    }
}

// Required by UIImagePickerController
extension ImagePreviewController: UINavigationControllerDelegate {}

extension ImagePreviewController: SettingsCoordinatorViewDelegate {

    func settingsDidChange(_ changes: SettingItems, coordinator: SettingsCoordinatorProtocol, animated: Bool) {
        os_log("Settings change detected")

        // Update the UI to show the new settings

        self.imageView.backgroundColor = coordinator.imageBackgroundColor

        self.setBleedStyle(coordinator.imageBleedStyle, animated: animated)

        // If the string is empty, show a helpful prompt
        var message = coordinator.message
        if message.isEmpty {
            message = Resources.sharedInstance.localizedString("MessagePromptText")
        }
        self.textLabel.text = message

        self.textLabel.textColor = coordinator.textColor
        self.textLabel.font = coordinator.textFont

        self.textBoxView.layer.backgroundColor = coordinator.boxColor.cgColor
        self.textBoxView.layer.borderWidth = coordinator.boxBorderWidth
        self.textBoxView.layer.cornerRadius = coordinator.boxCornerRadius

        self.textLabelCentreYConstraint.constant = coordinator.boxYCentreOffset
        
        // image will be nil if this is a plain colour
        // if image has changed:
        if changes.contains(.image) {
            self.imageView.image = coordinator.image
            self.configureImageViewSize()
        }
        
        if changes.contains(.scrollScale) {
           self.scrollView.zoomScale = coordinator.scrollScale
        }
        
        if changes.contains(.scrollOffset) {
            self.scrollView.contentOffset = coordinator.scrollOffset
        }
    }
}

extension ImagePreviewController: ColorPickerViewControllerDelegate {

    func colorPicker(_ picker: ColorPickerViewController, didChangeTo color: UIColor) {
        self.imageView.backgroundColor = color
        self.colorDidChange = true
    }

    func colorPickerWillClose(_ picker: ColorPickerViewController) {
        if self.colorDidChange {
            self.persistImageBackgroundColor()
        }

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

extension ImagePreviewController: UIScrollViewDelegate {

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }

    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        self.settingsCoordinator.scrollScale = scale
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            self.settingsCoordinator.scrollOffset = scrollView.contentOffset
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.settingsCoordinator.scrollOffset = scrollView.contentOffset
    }

    func aspectFillScale() -> CGFloat {

        guard let image = self.imageView.image,
            image.size.width > 0,
            image.size.height > 0 else {
            return 1.0
        }

        let xScale = self.renderableView.bounds.width/image.size.width
        let yScale = self.renderableView.bounds.height/image.size.height

        let result = max(xScale, yScale)

        return result
    }

    // Set up the constraints
    func configureImageViewSize() {

        guard let image = self.imageView.image else {
            self.imageViewWidthConstraint.constant = self.renderableView.bounds.width
            self.imageViewHeightConstraint.constant = self.renderableView.bounds.height

            return
        }

        let aspectFillScale = self.aspectFillScale()

        self.imageViewWidthConstraint.constant = image.size.width*aspectFillScale
        self.imageViewHeightConstraint.constant = image.size.height*aspectFillScale

        self.scrollView.setNeedsUpdateConstraints()
        self.scrollView.setNeedsLayout()
    }
    
    // Set the zoom to 1.0 and scroll to centre the image, as per initial state
    func setImageToDefaultPosition() {
        self.settingsCoordinator.startBatchChanges()
        
        self.settingsCoordinator.scrollScale = 1.0
        
        let overWidth = self.imageViewWidthConstraint.constant-self.scrollView.bounds.width
        let overHeight = self.imageViewHeightConstraint.constant-self.scrollView.bounds.height
        
        let offset = CGPoint(x: overWidth/2, y: overHeight/2)
        self.settingsCoordinator.scrollOffset = offset

        self.settingsCoordinator.endBatchChanges()
    }

}

extension ImagePreviewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        return true
    }
}
