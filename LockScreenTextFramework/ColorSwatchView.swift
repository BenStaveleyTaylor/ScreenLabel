//
//  ColorSwatchView.swift
//  LockScreenTextFramework
//
//  Created by Ben Staveley-Taylor on 26/11/2018.
//  Copyright © 2018 Ben Staveley-Taylor. All rights reserved.
//

import UIKit

/// Draws a solid color in a box, but with a background grid so the opacity can be judged.
open class ColorSwatchView: UIView {
    
    open var gridLineSpacing: CGFloat = 5
    open var gridLineWidth: CGFloat = 1
    open var gridColor: UIColor = UIColor.black
    
    open var swatchColor: UIColor? {
        get {
            return self.swatchView.backgroundColor
        }
        set {
            self.swatchView.backgroundColor = newValue
        }
    }
    
    // 'self' view is the grid background
    private lazy var swatchView = UIView(frame: self.frame)
    
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
    
    open override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
    }
    
    open override func draw(_ rect: CGRect) {
        
        // If the swatch is 100% opaque, no point doing any grid drawing as it will all be covered
        var swatchAlpha: CGFloat = 0
        self.swatchColor?.getRed(nil, green: nil, blue: nil, alpha: &swatchAlpha)
        
        if swatchAlpha == 1.0 {
            return
        }
        
        // Draw the grid, centered
        
        self.gridColor.setStroke()
        
        // Vertical lines
        let hSpaceUnused = self.bounds.width.truncatingRemainder(dividingBy: self.gridLineSpacing)
        var hPos = self.bounds.minX + hSpaceUnused/2
        let hMax = self.bounds.maxX + self.gridLineWidth/2
        while hPos < hMax {
            
            let path = UIBezierPath()
            path.move(to: CGPoint(x: hPos, y: self.bounds.minY))
            path.addLine(to: CGPoint(x: hPos, y: self.bounds.maxY))
            path.lineWidth = self.gridLineWidth
            path.stroke()
            
            hPos += self.gridLineSpacing
        }
        
        // Horizontal lines
        let vSpaceUnused = self.bounds.height.truncatingRemainder(dividingBy: self.gridLineSpacing)
        var vPos = self.bounds.minY + vSpaceUnused/2
        let vMax = self.bounds.maxY + self.gridLineWidth/2
        while vPos < vMax {
            
            let path = UIBezierPath()
            path.move(to: CGPoint(x: self.bounds.minX, y: vPos))
            path.addLine(to: CGPoint(x: self.bounds.maxX, y: vPos))
            path.lineWidth = self.gridLineWidth
            path.stroke()
            
            vPos += self.gridLineSpacing
        }
    }
    
    // -------------------------------------------------------------------------
    // Private
    // -------------------------------------------------------------------------
    
    private func commonSetup() {
        
        self.backgroundColor = UIColor.white
        
        // Create the subview
        self.swatchView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.swatchView)
        self.swatchView.constrainToFillSuperview()
    }
    
}
