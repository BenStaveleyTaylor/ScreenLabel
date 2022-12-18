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

    @IBOutlet private var timeLabel: UILabel!
    @IBOutlet private var dateLabel: UILabel!
    @IBOutlet private var footerLabel: UILabel!
    @IBOutlet private var leftFooterImageView: UIImageView!
    @IBOutlet private var rightFooterImageView: UIImageView!

    @IBOutlet private var timeLabelBaselineConstraint: NSLayoutConstraint!
    @IBOutlet private var dateLabelBaselineConstraint: NSLayoutConstraint!
    @IBOutlet private var footerLabelBaselineConstraint: NSLayoutConstraint!
    @IBOutlet private var footerImageWidthConstraint: NSLayoutConstraint!
    @IBOutlet private var footerImageCentreYToBottomOffsetConstraint: NSLayoutConstraint!
    @IBOutlet private var footerImageLeadingToCentreXConstraint: NSLayoutConstraint!
    @IBOutlet private var footerImageCentreXToTrailingConstraint: NSLayoutConstraint!

    @IBOutlet private var widgetContainerView: UIView!
    @IBOutlet private var widgetViewLeftConstraint: NSLayoutConstraint!
    @IBOutlet private var widgetViewTopConstraint: NSLayoutConstraint!
    @IBOutlet private var widgetWidthConstraint: NSLayoutConstraint!
    @IBOutlet private var widgetHeightConstraint: NSLayoutConstraint!

    let logic = LockScreenElements.create()
    var timer: Timer?

    // Tinting of the torch/camera icons
    let footerImageForegroundGrey: CGFloat = 0.9 // nearly white
    let footerImageBackgroundGrey: CGFloat = 0.25 // dark grey
    let footerImageForegroundAlpha: CGFloat = 1
    let footerImageBackgroundAlpha: CGFloat = 0.75

    // Special case: this subview can show/hide by user setting
    var showWidgetPreview: Bool = true {
        didSet {
            configureWidgetPreview()
        }
    }

    deinit {
        self.timer?.invalidate()
    }

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

        // Arrange for time to update as the clock changes
        if let timer = self.observeSystemMinuteChanges(notify: { date in
            DispatchQueue.main.async {
                self.setDateAndTimeText(at: date)
            }
        }) {
            RunLoop.current.add(timer, forMode: .common)
            self.timer = timer
        }

        configureWidgetPreview()
    }

    // Write values into the date and time fields
    // Defaults to current date/time
    func setDateAndTimeText(at date: Date = Date()) {

        self.timeLabel.text = self.logic.timeText()
        self.dateLabel.text = self.logic.dateText()
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
        let logic = LockScreenElements.create()

        self.footerLabelBaselineConstraint.constant = logic.footerBaseline
    }

    func configureWidgetPreview() {
        // Widget view only shows on iOS 16+ phones
        if self.logic.hasWidget && showWidgetPreview {
            self.widgetContainerView.isHidden = false

            let widgetRect = self.logic.widgetRect

            self.widgetWidthConstraint.constant = widgetRect.width
            self.widgetHeightConstraint.constant = widgetRect.height
            self.widgetViewLeftConstraint.constant = widgetRect.minX
            self.widgetViewTopConstraint.constant = widgetRect.minY
        } else {
            self.widgetContainerView.isHidden = true
        }
    }

    // MARK: Private

    // Update the time every time the minutes changes on the system clock
    private func observeSystemMinuteChanges(notify: @escaping ((_ date: Date) -> Void)) -> Timer? {

        let now = Date()

        // Time without seconds
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: now)
        let previousMinute = Calendar.current.date(from: components)
        if let nextMinute = previousMinute?.addingTimeInterval(60) {

            return Timer(fire: nextMinute,
                         interval: 60,
                         repeats: true) { thisTimer in
                            notify(thisTimer.fireDate)
            }
        }

        return nil
    }
}
