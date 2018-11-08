//
//  ViewController.swift
//  Lock Message
//
//  Created by Ben Staveley-Taylor on 06/11/2018.
//  Copyright © 2018 Ben Staveley-Taylor. All rights reserved.
//

import UIKit
import MobileCoreServices
import os.log

// Values of the viewStyleSegmentControl
enum ViewStyle: Int {
    case still, perspective
}

@objc
class ImagePreviewController: UIViewController {

    // Nib properties

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var textBoxView: UIView!
    @IBOutlet weak var helpButton: UIBarButtonItem!
    @IBOutlet weak var choosePhotoButton: UIBarButtonItem!
    @IBOutlet weak var plainColourButton: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var viewStyleSegmentControl: UISegmentedControl!
    @IBOutlet var imageTapRecognizer: UITapGestureRecognizer!
    @IBOutlet var textTapRecognizer: UITapGestureRecognizer!

    // Render this view to get the lock screen image
    @IBOutlet weak var renderableView: UIView!
    @IBOutlet weak var renderableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var renderableViewWidthConstraint: NSLayoutConstraint!
    
    // Local properties
    private var viewStyle: ViewStyle = .still

    // true if the controls are all hidden to show the whole view
    var isInPreviewMode = false

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        self.title = NSLocalizedString("ProductTitle", comment: "")
        self.helpButton.title = NSLocalizedString("HelpButtonText", comment: "")
        self.imageView.backgroundColor = UIColor.clear
        self.textLabel.text = NSLocalizedString("MessagePromptText", comment: "")

        self.viewStyleSegmentControl.setTitle(NSLocalizedString("StillViewStyle", comment: ""), forSegmentAt: 0)
        self.viewStyleSegmentControl.setTitle(NSLocalizedString("PerspectiveViewStyle", comment: ""), forSegmentAt: 1)

        self.viewStyleSegmentControl.layer.cornerRadius = 4
        self.viewStyleSegmentControl.layer.masksToBounds = true

        // TODO: read from settings
        self.viewStyleSegmentControl.selectedSegmentIndex = ViewStyle.still.rawValue

        self.formatText()
    }

    @IBAction func onHelpTapped(_ sender: Any) {
    }

    @IBAction func onChoosePhotoTapped(_ sender: Any) {

        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.mediaTypes = [kUTTypeImage as String]        // Still images only
        picker.delegate = self

        // We'll have to do our own cropping -- what you get back from UIImagePickerController is relatively low resolution
        picker.allowsEditing = false

        self.present(picker, animated: true)
    }

    @IBAction func onPlainColourTapped(_ sender: Any) {
    }

    @IBAction func onSaveTapped(_ sender: Any) {

        // Save the renderable view into the photo album then tell the user what to do

        let image = ImageUtilities.imageFromView(self.renderableView)

        UIImageWriteToSavedPhotosAlbum(image,
                                       self,
                                       #selector(image(_:didFinishSavingWithError:contextInfo:)),
                                       nil)
    }

    @objc
    func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: Any?) {

        let title: String
        let body: String

        if let error = error {
            os_log("Error saving image to Photos (%@)", "\(error)")

            title = NSLocalizedString("FailedAlertTitle", comment: "")
            body = error.localizedDescription
        }
        else {
            title = NSLocalizedString("SavedAlertTitle", comment: "")
            body = NSLocalizedString("HowToSetWallpaperBody", comment: "")
        }

        AlertUtilities.showMessage(title: title, body: body)
    }

    // When the image area is tapped, toggle the chrome off so the whole thing can be seen
    // Another tap toggles it back on again
    @objc
    @IBAction func onImageTapped(_ sender: Any) {
        self.togglePreviewMode()
        return
    }

    // Open the text attributes controller
    @objc
    @IBAction func onTextTapped(_ sender: Any) {
        return
    }

    // Segmented control changed from still to perspective
    @IBAction func onViewStyleChanged(_ sender: Any) {

        if let viewStyle = ViewStyle(rawValue: self.viewStyleSegmentControl.selectedSegmentIndex) {
            self.setViewStyle(viewStyle, animated: true)
        }
    }

    // MARK: Private methods

    // Apply formatting to the label
    private func formatText() {
        self.textLabel.textColor = UIColor.white

        self.textBoxView.layer.backgroundColor = UIColor(white: 0, alpha: 0.5).cgColor
        self.textBoxView.layer.cornerRadius = 6
    }

    private func togglePreviewMode() {

        self.isInPreviewMode.toggle()

        self.viewStyleSegmentControl.isHidden = self.isInPreviewMode

        self.navigationController?.setNavigationBarHidden(self.isInPreviewMode, animated: true)
        self.navigationController?.setToolbarHidden(self.isInPreviewMode, animated: true)

        // Can't push new VCs when the Navigation Bar is hidden, so disallow text editing
        self.textTapRecognizer.isEnabled = !self.isInPreviewMode
    }

    private func setViewStyle(_ viewStyle: ViewStyle, animated: Bool) {
        // When in perspective mode the image needs to bleed off the visible
        // area by 25 points all round to have material to work with when tilting

        let bleed: CGFloat
        switch viewStyle {
        case .still:
            bleed = 0

        case .perspective:
            bleed = 25
        }

        let duration: TimeInterval = animated ? 0.3 : 0
        UIView.animate(withDuration: duration) {
            self.renderableViewHeightConstraint.constant = 2*bleed
            self.renderableViewWidthConstraint.constant = 2*bleed
            self.view.layoutIfNeeded()
        }
    }

}

extension ImagePreviewController: UIImagePickerControllerDelegate {


    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        // info[.editedImage] should be what we want, but it is very low quality

        guard let originalImage = info[.originalImage] as? UIImage else {
            return
        }

        //        if let cropRect = info[.cropRect] as? CGRect {
        //            // TODO: Perform the crop
        //        }

        // TODO: Save image to file store
        // https://www.hackingwithswift.com/read/10/4/importing-photos-with-uiimagepickercontroller

        let data = originalImage.pngData()
        let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let url = URL(fileURLWithPath: documents).appendingPathComponent("pickedImage.png")
        try? data?.write(to: url)

        // Assign the image into the UI
        self.imageView.image = originalImage

        self.dismiss(animated: true)
    }

}

// Required by UIImagePickerController
extension ImagePreviewController: UINavigationControllerDelegate {}
