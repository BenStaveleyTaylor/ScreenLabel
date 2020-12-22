//
//  SizeDebugView.swift
//  LockScreenTextFramework
//
//  Created by Ben Staveley-Taylor on 07/05/2019.
//  Copyright © 2019 Ben Staveley-Taylor. All rights reserved.
//

import UIKit

// Draw rules on the view so we can see what size gets used
class SizeDebugView: UIView {

    @IBOutlet private var sizeLabel: UILabel!

    let overlayColor: UIColor = .blue

    let axisStrokeWidth: CGFloat = 2

    let majorTickWidth: CGFloat = 2
    let majorTickSpacing: CGFloat = 50
    let majorTickLength: CGFloat = 40
    let minorTickWidth: CGFloat = 1
    let minorTickSpacing: CGFloat = 10
    let minorTickLength: CGFloat = 15

    let labelSize: CGFloat = 12

    override func awakeFromNib() {
        super.awakeFromNib()

        self.sizeLabel.textColor = self.overlayColor
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.sizeLabel.text = "w: \(Int(self.bounds.width)), h: \(Int(self.bounds.height))"
    }

    override func draw(_ rect: CGRect) {

        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }

        context.setStrokeColor(self.overlayColor.cgColor)

        let midX = self.bounds.midX
        let midY = self.bounds.midY
        let maxX = self.bounds.maxX
        let maxY = self.bounds.maxY

        context.beginPath()
        context.setLineWidth(self.axisStrokeWidth)

        // Vertical centre
        context.move(to: CGPoint(x: midX, y: 0))
        context.addLine(to: CGPoint(x: midX, y: maxY))

        // Horizontal centre
        context.move(to: CGPoint(x: 0, y: midY))
        context.addLine(to: CGPoint(x: maxX, y: midY))

        context.strokePath()

        context.beginPath()
        context.setLineWidth(self.minorTickWidth)

        // Small crosshatch every 10 points along vertical centre
        self.addCrossTicks(context: context, spacing: self.minorTickSpacing, length: self.minorTickLength, stroke: self.minorTickWidth, labels: false)

        // Large crosshatch every 50 points along vertical centre
        self.addCrossTicks(context: context, spacing: self.majorTickSpacing, length: self.majorTickLength, stroke: self.majorTickWidth, labels: true)
    }

    internal func addCrossTicks(context: CGContext, spacing: CGFloat, length: CGFloat, stroke: CGFloat, labels: Bool) {

        let midX = self.bounds.midX
        let midY = self.bounds.midY
        let maxX = self.bounds.maxX
        let maxY = self.bounds.maxY

        context.beginPath()

        var dy = spacing
        while dy < (midY-spacing) {

            context.move(to: CGPoint(x: midX-length/2, y: dy))
            context.addLine(to: CGPoint(x: midX+length/2, y: dy))

            context.move(to: CGPoint(x: midX-length/2, y: maxY-dy))
            context.addLine(to: CGPoint(x: midX+length/2, y: maxY-dy))

            dy += spacing
        }

        var dx = spacing
        while dx < (midX-spacing) {

            context.move(to: CGPoint(x: dx, y: midY-length/2))
            context.addLine(to: CGPoint(x: dx, y: midY+length/2))

            context.move(to: CGPoint(x: maxX-dx, y: midY-length/2))
            context.addLine(to: CGPoint(x: maxX-dx, y: midY+length/2))

            dx += spacing
        }

        context.setLineWidth(stroke)
        context.strokePath()

        if !labels {
            return
        }

        // Draw labels by the major tick marks
        // Vertical ones go to the right of the Y-axis
        // Horizontal ones go below the X-axis

        let font = UIFont.systemFont(ofSize: self.labelSize)

        let yParagraphStyle = NSMutableParagraphStyle()
        yParagraphStyle.alignment = .left

        let yAttrs: [NSAttributedString.Key: Any] = [.font: font,
                                                     .paragraphStyle: yParagraphStyle,
                                                     .foregroundColor: self.overlayColor]
        dy = spacing
        while dy < (midY-spacing) {

            let text = String(Int(dy))

            let topRect = CGRect(x: midX+length/2+6, y: dy-self.labelSize/2, width: 100, height: self.labelSize)
            let bottomRect = CGRect(x: midX+length/2+6, y: maxY-dy-self.labelSize/2, width: 100, height: self.labelSize)

            text.draw(with: topRect, options: .usesLineFragmentOrigin, attributes: yAttrs, context: nil)
            text.draw(with: bottomRect, options: .usesLineFragmentOrigin, attributes: yAttrs, context: nil)

            dy += spacing
        }

        let xParagraphStyle = NSMutableParagraphStyle()
        xParagraphStyle.alignment = .center

        let xAttrs: [NSAttributedString.Key: Any] = [.font: font,
                                                     .paragraphStyle: xParagraphStyle,
                                                     .foregroundColor: self.overlayColor]

        dx = spacing
        while dx < (midX-spacing) {

            context.move(to: CGPoint(x: dx, y: midY-length/2))
            context.addLine(to: CGPoint(x: dx, y: midY+length/2))

            context.move(to: CGPoint(x: maxX-dx, y: midY-length/2))
            context.addLine(to: CGPoint(x: maxX-dx, y: midY+length/2))

            let text = String(Int(dx))

            let leftRect = CGRect(x: dx-50, y: midY+length/2+6, width: 100, height: self.labelSize)
            let rightRect = CGRect(x: maxX-dx-50, y: midY+length/2+6, width: 100, height: self.labelSize)

            text.draw(with: leftRect, options: .usesLineFragmentOrigin, attributes: xAttrs, context: nil)
            text.draw(with: rightRect, options: .usesLineFragmentOrigin, attributes: xAttrs, context: nil)

            dx += spacing
        }
    }
}
