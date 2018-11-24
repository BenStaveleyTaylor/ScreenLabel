//
//  FontPickerViewController.swift
//  LockScreenTextFramework
//
//  Created by Ben Staveley-Taylor on 24/11/2018.
//  Copyright © 2018 Ben Staveley-Taylor. All rights reserved.
//

import UIKit

protocol FontPickerViewControllerDelegate: AnyObject {

    // The selected font name has changed
    func didChangeSelectedFont(name: String)
}

class FontPickerViewController: UITableViewController {

    let sampleText = "Jackdaws love my big sphinx of quartz 123457890"

    var selectedFontName: String?
    weak var delegate: FontPickerViewControllerDelegate?

    lazy var fontNames: [String] = {

        var names: [String] = []

        for family in UIFont.familyNames.sorted() {

            let styleNames = UIFont.fontNames(forFamilyName: family).sorted()
            names.append(contentsOf: styleNames)
        }

        return names
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

// UITableViewDataSource
extension FontPickerViewController {

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.fontNames.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "fontPickerCell", for: indexPath)

        // Use the right font for the cell title
        let fontName = self.fontNames[indexPath.row]
        let font = UIFont(name: fontName, size: cell.textLabel?.font.pointSize ?? 12)
        cell.textLabel?.font = font
        cell.textLabel?.text = self.sampleText

        cell.detailTextLabel?.text = fontName

        // If this is the selected cell, show a tick
        if fontName == self.selectedFontName {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell = tableView.cellForRow(at: indexPath)
        if let fontName = selectedCell?.textLabel?.font.fontName {

            self.delegate?.didChangeSelectedFont(name: fontName)
        }
    }

}
