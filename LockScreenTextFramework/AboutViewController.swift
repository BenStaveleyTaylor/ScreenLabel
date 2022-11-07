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

    @IBOutlet private var iconImage: UIImageView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var versionLabel: UILabel!
    @IBOutlet private var copyrightLabel: UILabel!
    @IBOutlet private var contactButton: UIButton!
    @IBOutlet private var webSiteButton: UIButton!
    @IBOutlet private var privacyButton: UIButton!
    @IBOutlet private var translatorsLabel: UILabel!

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
        self.productTitle = Resources.sharedInstance.appName
        self.copyrightNotice = Resources.sharedInstance.localizedString("CopyrightNotice")
        self.emailButtonFormat = Resources.sharedInstance.localizedString("EmailButtonFormat")
        self.privacyButtonTitle = Resources.sharedInstance.localizedString("PrivacyButtonTitle")

        let appVersion: String? = appBundle.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
        let versionTemplate = Resources.sharedInstance.localizedString("VersionTemplate")
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

        // Round the corners: for 1 60px wide box the radius should be 12
        self.iconImage.layer.cornerRadius = self.iconImage.bounds.width/5
        self.iconImage.clipsToBounds = true

        self.titleLabel.text = self.productTitle
        self.versionLabel.text = self.versionString
        self.copyrightLabel.text = self.copyrightNotice

        let emailButtonText = String(format: self.emailButtonFormat, self.emailAddress)
        self.contactButton.setTitle(emailButtonText, for: .normal)

        self.webSiteButton.setTitle(self.webSiteAddress, for: .normal)

        self.privacyButton.setTitle(self.privacyButtonTitle, for: .normal)

        self.translatorsLabel.attributedText = translatorsText()

        self.title = Resources.sharedInstance.localizedString("AboutTitle")
    }

    @IBAction private func onContactButtonTapped(_ sender: UIButton) {

        // Using mailto: in preference to MFMailComposeViewController
        // because it honors the user's preferred mail app setting

        let emailSubject = Resources.sharedInstance.localizedString("EmailSubjectTemplate")
        let emailBody = self.composeSupportEmailBody()

        var components = URLComponents()
        components.scheme = "mailto"
        components.path = self.emailAddress
        components.queryItems = [
            URLQueryItem(name: "subject", value: emailSubject),
            URLQueryItem(name: "body", value: emailBody)
        ]

        guard let mailtoUrl = components.url else {
            os_log("Error building email URL from: %@", "\(components)")
            return
        }

        UIApplication.shared.open(mailtoUrl) { success in
            if !success {
                os_log("Unable to compose email to: %@", mailtoUrl.absoluteString)
            }
        }
    }

    internal func composeSupportEmailBody() -> String {

        let language = Locale.current.languageCode ?? "??"
        let region = Locale.current.regionCode ?? "??"

        // Body is "Version: nnn"
        // Not localised because I need to read it
        let result = """
        App Version: \(self.versionString)
        Device: \(UIDevice.current.model), \(UIDevice.current.systemName) \(UIDevice.current.systemVersion)
        Language/Region: \(language)_\(region)
        (If possible, please write your email in English 🙂)

        * * * * *

        """

        return result
    }

    internal func translatorsText() -> NSMutableAttributedString {
        let title = Resources.sharedInstance.localizedString("TranslatorsTitle")
        let people = Resources.sharedInstance.localizedString("TranslatorsList")
        let combined = NSMutableAttributedString(string: title + " " + people)

        let size: CGFloat = 15.0
        let plainFont = UIFont.systemFont(ofSize: size)
        let boldFont = UIFont.boldSystemFont(ofSize: size)

        combined.addAttribute(
            NSAttributedString.Key.font,
            value: boldFont,
            range: NSRange(location: 0, length: title.count))

        // Include the space separator
        combined.addAttribute(
            NSAttributedString.Key.font,
            value: plainFont,
            range: NSRange(location: title.count, length: people.count+1))

        return combined
    }

    @IBAction private func onWebSiteButtonTapped(_ sender: UIButton) {
        UIApplication.shared.open(self.webSiteLink)
    }

    @IBAction private func onPrivacyButtonTapped(_ sender: UIButton) {
        UIApplication.shared.open(self.privacyPolicyLink)
    }

    // Handler for the Done button
    @IBAction private func onDoneTapped(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension AboutViewController: MFMailComposeViewControllerDelegate {

    public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {

        // Dismiss the mail compose view controller.
        controller.dismiss(animated: true, completion: nil)
    }
}
