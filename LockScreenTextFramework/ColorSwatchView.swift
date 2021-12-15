//
//  ColorSwatchView.swift
//  LockScreenTextFramework
//
//  Created by Ben Staveley-Taylor on 30/11/2018.
//  Copyright © 2018 Ben Staveley-Taylor. All rights reserved.
//

import UIKit

/// A view to show a block of colour with an optional stripe when transparent
class ColorSwatchView: UIView {

    /// The colour to display
    var color: UIColor? {
        get {
            return self.backgroundColor
        }
        set {
            self.backgroundColor = newValue
        }
    }

    /// If true, when the colour swatch hits zero alpha a diagonal line
    /// is drawn to indicate that, rather than drawing nothing.
    var showZeroAlphaAsStripe = true
    var zeroAlphaLineWidth: CGFloat = 2
    var zeroAlphaLineColor = UIColor.red

    override func draw(_ rect: CGRect) {

        // If there is no background colour, draw a stripe
        if showZeroAlphaAsStripe && self.alpha() < 0.01 {

            let path = UIBezierPath()

            path.move(to: CGPoint(x: self.bounds.minX, y: self.bounds.maxY))
            path.addLine(to: CGPoint(x: self.bounds.maxX, y: self.bounds.minY))
            path.lineWidth = self.zeroAlphaLineWidth
            self.zeroAlphaLineColor.setStroke()

            path.stroke()
        }
    }

    func alpha() -> CGFloat {
        var alpha: CGFloat = 0

        self.color?.getRed(nil, green: nil, blue: nil, alpha: &alpha)

        return alpha
    }
}
