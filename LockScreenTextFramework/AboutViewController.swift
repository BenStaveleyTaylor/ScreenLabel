//
//  AboutViewController.swift
//  LockScreenTextFramework
//
//  Created by Ben Staveley-Taylor on 30/12/2018.
//  Copyright © 2018 Ben Staveley-Taylor. All rights reserved.
//

import UIKit
import MessageUI
import os.log

class AboutViewController: UIViewController {

    @IBOutlet private weak var iconImage: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var versionLabel: UILabel!
    @IBOutlet private weak var copyrightLabel: UILabel!
    @IBOutlet private weak var contactButton: UIButton!
    @IBOutlet private weak var webSiteButton: UIButton!
    @IBOutlet private weak var privacyButton: UIButton!

    let emailAddress = "bstiosdev@icloud.com"
    let webSiteAddress = "https://www.staveleytaylor.com"
    let privacyPolicyPath = "privacy.html"

    let productTitle: String
    let copyrightNotice: String
    let emailButtonFormat: String
    let privacyButtonTitle: String
    let versionString: String
    let webSiteLink: URL!
    let privacyPolicyLink: URL!

    // Class method to create the ViewController

    class func create() -> AboutViewController {

        let bundle = Bundle(for: self)
        let className = String(describing: self)
        let storyboard = UIStoryboard(name: "Main", bundle: bundle)

        // swiftlint:disable:next force_cast
        return storyboard.instantiateViewController(withIdentifier: className) as! AboutViewController
    }

    required init?(coder aDecoder: NSCoder) {
        // Load the strings
        let appBundle = Bundle.main
        self.productTitle = Resources.localizedString("ProductTitle")
        self.copyrightNotice = Resources.localizedString("CopyrightNotice")
        self.emailButtonFormat = Resources.localizedString("EmailButtonFormat")
        self.privacyButtonTitle = Resources.localizedString("PrivacyButtonTitle")

        let appVersion: String? = appBundle.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
        let versionTemplate = Resources.localizedString("VersionTemplate")
        self.versionString = String(format: versionTemplate, appVersion ?? "–")

        let baseUrl = URL(string: self.webSiteAddress)
        self.webSiteLink = baseUrl
        self.privacyPolicyLink = baseUrl?.appendingPathComponent(self.privacyPolicyPath, isDirectory: false)

        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Populate the fields

        // Start with the iPhone icon
        var icon = UIImage(named: "AppIcon60x60")
        if icon == nil {
            // If not found try the iPad icon
            icon = UIImage(named: "AppIcon76x76")
        }
        self.iconImage.image = icon

        self.titleLabel.text = self.productTitle
        self.versionLabel.text = self.versionString
        self.copyrightLabel.text = self.copyrightNotice

        let emailButtonText = String(format: self.emailButtonFormat, self.emailAddress)
        self.contactButton.setTitle(emailButtonText, for: .normal)

        self.webSiteButton.setTitle(self.webSiteAddress, for: .normal)

        self.privacyButton.setTitle(self.privacyButtonTitle, for: .normal)
    }

    @IBAction private func onContactButtonTapped(_ sender: UIButton) {

        // Allow the user to send me an email
        guard MFMailComposeViewController.canSendMail() else {
            os_log("Mail services are not available")
            return
        }

        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self

        // Configure the fields of the interface.
        composeVC.setToRecipients([self.emailAddress])

        // Subject line
        let emailSubjectTemplate = Resources.localizedString("EmailSubjectTemplate")
        let emailSubject = String(format: emailSubjectTemplate, self.productTitle)
        composeVC.setSubject(emailSubject)

        // Body is "Version: nnn"
        // Not localised because I need to read it
        let emailBodyTemplate = Resources.localizedString("EmailBodyTemplate")
        let emailBody = String(format: emailBodyTemplate, self.versionString)
        composeVC.setMessageBody(emailBody, isHTML: false)

        // Present the view controller modally.
        self.present(composeVC, animated: true, completion: nil)
    }

    @IBAction private func onWebSiteButtoTapped(_ sender: UIButton) {
        UIApplication.shared.open(self.webSiteLink)
    }
    
    @IBAction private func onPrivacyButtonTapped(_ sender: UIButton) {
        UIApplication.shared.open(self.privacyPolicyLink)
    }
}

extension AboutViewController: MFMailComposeViewControllerDelegate {

    public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {

        // Dismiss the mail compose view controller.
        controller.dismiss(animated: true, completion: nil)
    }
}
