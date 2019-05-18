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
    func didChangeSelectedFont(internalName: String)
}

class FontPickerViewController: UITableViewController {

    let sampleText = Resources.sharedInstance.localizedString("FontPickerSample")

    var selectedFontInternalName: String?

    weak var delegate: FontPickerViewControllerDelegate?

    // List of all font names, sorted
    lazy var fontInternalNames: [String] = {

        // Top entry is always "System Font"
        var names: [String] = [ TextAttributesHelper.systemFontInternalName ]
        names.append(contentsOf: UIFont.familyNames.sorted())

        return names
    }()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        for cell in self.tableView.visibleCells {
            self.setCellCheckmarkState(cell: cell)
        }
    }

    private func setCellCheckmarkState(cell: UITableViewCell) {

        let fontDisplayName = cell.detailTextLabel?.text ?? ""
        let fontInternalName = TextAttributesHelper.fontInternalNameFrom(displayName: fontDisplayName)

        if fontInternalName == self.selectedFontInternalName {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
    }
}

// UITableViewDataSource
extension FontPickerViewController {

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.fontInternalNames.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "fontPickerCell", for: indexPath)

        let sizeToUse: CGFloat = cell.textLabel?.font.pointSize ?? 12
        let fontInternalName = self.fontInternalNames[indexPath.row]
        let fontDisplayName = TextAttributesHelper.fontDisplayNameFrom(internalName: fontInternalName)

        // Use the right font for the cell title
        let font: UIFont?

        if indexPath.row == 0 {
            // System font
            font = UIFont.systemFont(ofSize: sizeToUse)
        } else {
            font = UIFont(name: fontInternalName, size: sizeToUse)
        }

        cell.textLabel?.font = font
        cell.textLabel?.text = self.sampleText
        cell.detailTextLabel?.text = fontDisplayName

        self.setCellCheckmarkState(cell: cell)

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let selectedCell = tableView.cellForRow(at: indexPath)
        if let familyName = selectedCell?.textLabel?.font.familyName {
            self.delegate?.didChangeSelectedFont(internalName: familyName)
        }
    }
}
