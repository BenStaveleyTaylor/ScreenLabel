//
//  LockScreenElementsView.swift
//  LockScreenTextFramework
//
//  Created by Ben Staveley-Taylor on 27/04/2019.
//  Copyright © 2019 Ben Staveley-Taylor. All rights reserved.
//

import UIKit

/// Draw a simulation of the lock screen elements -- the time/date box
/// and any icons in the footer area. This is all empirical.
///
/// We assume this view fills the device screen
class LockScreenElementsView: UIView {

    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var footerLabel: UILabel!
    @IBOutlet private weak var leftFooterImageView: UIImageView!
    @IBOutlet private weak var rightFooterImageView: UIImageView!

    @IBOutlet private weak var timeLabelBaselineConstraint: NSLayoutConstraint!
    @IBOutlet private weak var dateLabelBaselineConstraint: NSLayoutConstraint!
    @IBOutlet private weak var footerLabelBaselineConstraint: NSLayoutConstraint!
    @IBOutlet private weak var footerImageWidthConstraint: NSLayoutConstraint!
    @IBOutlet private weak var footerImageCentreYToBottomOffsetConstraint: NSLayoutConstraint!
    @IBOutlet private weak var footerImageLeadingToCentreXConstraint: NSLayoutConstraint!
    @IBOutlet private weak var footerImageCentreXToTrailingConstraint: NSLayoutConstraint!

    let logic = LockScreenElements()
    var timer: Timer?

    let footerImageForegroundGrey: CGFloat = 0.68
    let footerImageBackgroundGrey: CGFloat = 0.75
    let footerImageForegroundAlpha: CGFloat = 1
    let footerImageBackgroundAlpha: CGFloat = 0.75

    override func awakeFromNib() {
        super.awakeFromNib()
        self.commonInit()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.setMutableConstraints()
    }

    func commonInit() {

        self.timeLabel.font = self.logic.timeFont
        self.dateLabel.font = self.logic.dateFont
        self.footerLabel.font = self.logic.footerFont

        // Do the layout
        self.setImmutableContraints()

        // Show date and time right now
        self.setDateAndTimeText()

        self.footerLabel.isHidden = !self.logic.hasFooterText
        self.footerLabel.text = self.logic.footerText

        for view in [self.leftFooterImageView, self.rightFooterImageView] {
            view?.isHidden = !self.logic.hasFooterIcons
            view?.clipsToBounds = true
            view?.backgroundColor = UIColor(white: footerImageBackgroundGrey, alpha: footerImageBackgroundAlpha)
            view?.tintColor = UIColor(white: footerImageForegroundGrey, alpha: footerImageForegroundAlpha)
        }

        #warning("TODO")
        // Arrange for time to update as the clock changes
        //        let timer = self.logic.observeSystemMinuteChanges { date in
        //            DispatchQueue.main.async {
        //                self.setDateAndTimeText(at: date)
        //            }
        //        }
        //
        //        RunLoop.current.add(timer, forMode: .RunLoop.Mode.common)
        //        self.timer = timer

    }

    // Write values into the date and time fields
    // Defaults to current date/time
    func setDateAndTimeText(at date: Date = Date()) {

        self.timeLabel.text = self.logic.timeText
        self.dateLabel.text = self.logic.dateText
    }

    // Set constraints that don't change even with device rotation
    func setImmutableContraints() {
        
        self.timeLabelBaselineConstraint.constant = self.logic.timeBaseline
        self.dateLabelBaselineConstraint.constant = self.logic.dateBaseline

        let imageWidth = self.logic.footerImageWidth
        self.footerImageWidthConstraint.constant = imageWidth
        
        // Turn the images into into a circle
        self.leftFooterImageView.layer.cornerRadius = imageWidth/2
        self.rightFooterImageView.layer.cornerRadius = imageWidth/2
        
        self.footerImageLeadingToCentreXConstraint.constant = self.logic.footerImageEdgeToCentreXInset
        self.footerImageCentreXToTrailingConstraint.constant = self.logic.footerImageEdgeToCentreXInset
        self.footerImageCentreYToBottomOffsetConstraint.constant = logic.footerCentreYToBottomEdge
    }

    // Constraints tjhat can change during the view's life
    func setMutableConstraints() {

        // Get a transient logic object with layout for the current state
        let logic = LockScreenElements()

        self.footerLabelBaselineConstraint.constant = logic.footerBaseline
    }
}
