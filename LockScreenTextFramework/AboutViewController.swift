//
//  AboutViewController.swift
//  LockScreenTextFramework
//
//  Created by Ben Staveley-Taylor on 30/12/2018.
//  Copyright © 2018 Ben Staveley-Taylor. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {

    @IBOutlet private weak var iconImage: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var versionLabel: UILabel!
    @IBOutlet private weak var copyrightLabel: UILabel!
    @IBOutlet private weak var contactLabel: UILabel!

    // Class method to create the ViewController

    class func create() -> AboutViewController {

        let bundle = Bundle(for: self)
        let className = String(describing: self)
        let storyboard = UIStoryboard(name: "Main", bundle: bundle)

        // swiftlint:disable:next force_cast
        return storyboard.instantiateViewController(withIdentifier: className) as! AboutViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Populate the fields
        let appBundle = Bundle.main

        // Start with the iPhone icon
        var icon = UIImage(named: "AppIcon60x60")
        if icon == nil {
            // If not found try the iPad icon
            icon = UIImage(named: "AppIcon76x76")
        }
        self.iconImage.image = icon

        self.titleLabel.text = Resources.localizedString("ProductTitle")

        let appVersion: String? = appBundle.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
        let versionTemplate = Resources.localizedString("VersionTemplate")
        self.versionLabel.text = String(format: versionTemplate, appVersion ?? "–")

        self.copyrightLabel.text = Resources.localizedString("CopyrightNotice")

        self.contactLabel.text = Resources.localizedString("ContactInfo")
    }

}
