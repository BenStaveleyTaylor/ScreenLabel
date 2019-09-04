//
//  TranslucentColorSwatchView.swift
//  LockScreenTextFramework
//
//  Created by Ben Staveley-Taylor on 26/11/2018.
//  Copyright © 2018 Ben Staveley-Taylor. All rights reserved.
//

import UIKit

/// Draws a solid color in a box, but with a background image so the opacity can be judged.
open class TranslucentColorSwatchView: UIView {

    /// If true, the colour swatch has a background image which shows
    /// through as the alpha of the colour decreases.
    public var showOpacity: Bool = true {
        didSet {
            self.backgroundImageView.isHidden = !showOpacity
        }
    }

    /// If true, when the colour swatch hits zero alpha a diagonal line
    /// is drawn to indicate that, rather than drawing nothing.
    public var showZeroAlphaAsStripe: Bool {
        get {
            return self.swatchView.showZeroAlphaAsStripe
        }
        set {
            self.swatchView.showZeroAlphaAsStripe = newValue
        }
    }

    open var swatchColor: UIColor? {
        get {
            return self.swatchView.color
        }
        set {
            self.swatchView.color = newValue

            // If the swatch is opaque, no background image is needed
            let backgroundImageVisible = showOpacity && self.swatchView.alpha() < 1.0
            self.backgroundImageView.isHidden = !backgroundImageVisible
        }
    }

    // 'self' view is the grid background
    private lazy var swatchView = ColorSwatchView(frame: self.bounds)
    private lazy var backgroundImageView = UIImageView(frame: self.bounds)

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonSetup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        // Rest of the init is done in awakeFromNib
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        self.commonSetup()
    }

    // -------------------------------------------------------------------------
    // Private
    // -------------------------------------------------------------------------

    private func commonSetup() {
        
        self.backgroundColor = UIColor.white

        self.backgroundImageView.image = Resources.sharedInstance.image(named: "ColorSwatchBackground")

        // Create the subviews
        self.backgroundImageView.contentMode = .scaleAspectFill
        self.backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.backgroundImageView)
        self.backgroundImageView.constrainToFillSuperview()

        self.swatchView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.swatchView)
        self.swatchView.constrainToFillSuperview()
    }
    
}
