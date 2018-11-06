//
//  ViewController.swift
//  Lock Message
//
//  Created by Ben Staveley-Taylor on 06/11/2018.
//  Copyright © 2018 Ben Staveley-Taylor. All rights reserved.
//

import UIKit

class ImagePreviewController: UIViewController {

    // Nib properties

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var helpButton: UIBarButtonItem!
    @IBOutlet weak var choosePhotoButton: UIBarButtonItem!
    @IBOutlet weak var plainColourButton: UIBarButtonItem!
    @IBOutlet weak var actionButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        self.title = NSLocalizedString("ProductTitle", comment: "")
        self.helpButton.title = NSLocalizedString("HelpButtonText", comment: "")
        self.imageView.backgroundColor = UIColor.clear
        self.textLabel.text = NSLocalizedString("MessagePromptText", comment: "")
    }

    @IBAction func onHelpTapped(_ sender: Any) {
    }

    @IBAction func onChoosePhotoTapped(_ sender: Any) {

        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        picker.delegate = self

        self.present(picker, animated: true)
    }

    @IBAction func onPlainColourTapped(_ sender: Any) {
    }
    
    @IBAction func onActionTapped(_ sender: Any) {
    }

    // When the image area is tapped, toggle the chrome off so the whole thing can be seen
    // Another tap toggles it back on again
    @IBAction func onImageTapped(_ sender: Any) {
    }
}

extension ImagePreviewController: UIImagePickerControllerDelegate {


    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        var newImage: UIImage

        if let possibleImage = info[.editedImage] as? UIImage {
            newImage = possibleImage
        } else if let possibleImage = info[.originalImage] as? UIImage {
            newImage = possibleImage
        } else {
            return
        }

        // Assign the image into the UI
        self.imageView.image = newImage

        self.dismiss(animated: true)
   }

}

extension ImagePreviewController: UINavigationControllerDelegate {

}
