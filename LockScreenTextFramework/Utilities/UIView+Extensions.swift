//
//  UIView+Extensions.swift
//  LockScreenTextFramework
//
//  Created by Ben Staveley-Taylor on 26/11/2018.
//  Copyright © 2018 Ben Staveley-Taylor. All rights reserved.
//

import Foundation

extension UIView {

    /// Set constraints so the child view always resizes to match its superview
    public func constrainToFillSuperview() {

        guard let superview = self.superview else {
            assertionFailure("No superview found. View must be added to a hierarchy first")
            return
        }

        // Remove old constraints that might conflict
        NSLayoutConstraint.deactivate(self.constraints)

        let newConstraints: [NSLayoutConstraint] = [
            self.leftAnchor.constraint(equalTo: superview.leftAnchor),
            self.rightAnchor.constraint(equalTo: superview.rightAnchor),
            self.topAnchor.constraint(equalTo: superview.topAnchor),
            self.bottomAnchor.constraint(equalTo: superview.bottomAnchor)
        ]

        NSLayoutConstraint.activate(newConstraints)
    }

    // Set a standard 1pt gray border
    public func setBorder(color: UIColor = UIColor.gray, width: CGFloat = 1) {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = width
    }
}
