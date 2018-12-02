//
//  ColorPickerViewController.swift
//  LockScreenTextFramework
//
//  Created by Ben Staveley-Taylor on 02/12/2018.
//  Copyright © 2018 Ben Staveley-Taylor. All rights reserved.
//

import UIKit

// Client must implement this
protocol ColorPickerViewControllerDelegate: AnyObject {

    // User has selected a new color. This happens many times before a final "OK"
    // For example as the user pans around the color wheel, this is issues repeatedly
    func colorDidChange(to: UIColor)

}

class ColorPickerViewController: UIViewController {

    // MARK: Nib properties

    @IBOutlet private weak var colorWheelImageView: UIImageView!
    @IBOutlet private weak var swatchesStack: UIStackView!
    @IBOutlet private weak var lighterLabel: UILabel!
    @IBOutlet private weak var brightnessSlider: UISlider!
    @IBOutlet private weak var darkerLabel: UILabel!
    @IBOutlet private weak var clearerLabel: UILabel!
    @IBOutlet private weak var transparencySlider: UISlider!
    @IBOutlet private weak var opaquerLabel: UILabel!
    @IBOutlet private weak var beforeSwatch: TranslucentColorSwatchView!
    @IBOutlet private weak var beforeLabel: UILabel!
    @IBOutlet private weak var afterSwatch: TranslucentColorSwatchView!
    @IBOutlet private weak var afterLabel: UILabel!

    // MARK: Other properties

    var beforeColor: UIColor = UIColor.white {
        didSet {
            self.beforeSwatch.swatchColor = self.beforeColor
        }
    }
    var selectedColor: UIColor = UIColor.white {
        didSet {
            self.afterSwatch.swatchColor = self.selectedColor
            self.delegate?.colorDidChange(to: self.selectedColor)
        }
    }
    weak var delegate: ColorPickerViewControllerDelegate?

    var startingColor: UIColor?

    // MARK: View lifecycle

    convenience init(startingColor: UIColor, delegate: ColorPickerViewControllerDelegate?) {

        let selfClass = type(of: self)
        let className = String(describing: selfClass)
        let bundle = Bundle(for: selfClass)
        self.init(nibName: className, bundle: bundle)

        self.startingColor = startingColor
        self.delegate = delegate
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set borders on all color swatches
        for swatch in self.swatchesStack.subviews {
            swatch.setBorder()
        }
        self.beforeSwatch.setBorder()
        self.afterSwatch.setBorder()

        // Start with no color change
        if let startingColor = self.startingColor {
            self.beforeColor = startingColor
            self.selectedColor = startingColor
        }
    }

    // -------------------------------------------------------------------------
    // MARK: Actions from the UI
    // -------------------------------------------------------------------------

    @IBAction private func onColorWheelPan(_ sender: UIPanGestureRecognizer) {
    }

    @IBAction private func onColorSwatchTap(_ sender: UITapGestureRecognizer) {

        if let selectedColor = sender.view?.backgroundColor {
            self.selectedColor = selectedColor
        }
    }

    // -------------------------------------------------------------------------
    // MARK: Private methods
    // -------------------------------------------------------------------------

}
