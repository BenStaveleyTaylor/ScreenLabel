//
//  HelpPageController.swift
//  LockScreenTextFramework
//
//  Created by Ben Staveley-Taylor on 30/12/2018.
//  Copyright © 2018 Ben Staveley-Taylor. All rights reserved.
//

import UIKit

class HelpPageController: UIViewController {

    @IBOutlet private weak var helpTitle: UILabel!
    @IBOutlet private weak var helpImage: UIImageView!
    @IBOutlet private weak var helpText: UILabel!

    private var helpTitleValue: String?
    private var helpImageValue: UIImage?
    private var helpTextValue: String?

    class func create(title: String?, image: UIImage?, text: String?) -> HelpPageController {

        let bundle = Bundle(for: self)
        let className = String(describing: self)
        let storyboard = UIStoryboard(name: "Help", bundle: bundle)

        // swiftlint:disable:next force_cast
        let result = storyboard.instantiateViewController(withIdentifier: className) as! HelpPageController

        result.helpTitleValue = title
        result.helpImageValue = image
        result.helpTextValue = text

        return result
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.helpTitle.text = self.helpTitleValue
        self.helpImage.image = self.helpImageValue
        self.helpText.text = self.helpTextValue
    }
}
