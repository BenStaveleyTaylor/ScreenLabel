//
//  LockScreenTextWidget.swift
//  LockScreenTextWidget
//
//  Created by Ben Staveley-Taylor on 23/10/2022.
//  Copyright © 2022 Ben Staveley-Taylor. All rights reserved.
//

import WidgetKit
import SwiftUI
import os.log
import LockScreenTextExtensionFramework

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(
            message: Resources.sharedInstance.localizedString("Widget_PlaceholderText")
        )
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        let message = displayMessage(in: context)
        let entry = SimpleEntry(message: message)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        let message = displayMessage(in: context)
        let entry = SimpleEntry(message: message)

        let entries = [entry]

        // Message will be updated from the main app if the user edits the settings
        let timeline = Timeline(entries: entries, policy: .never)
        completion(timeline)
    }

    // The message as set up in the app's settings
    func userConfigMessage() -> String {
        var message: String?
        if let savedSettings = Settings.readFromUserDefaults(Defaults.location) {
            message = savedSettings.message
        }

        return message ?? ""
    }

    // The overall message to show
    func displayMessage(in context: Context) -> String {
        var message = userConfigMessage()
        if message.isEmpty {
            let fallbackKey = context.isPreview ? "Widget_PlaceholderText" : "Widget_NoLabelSet"
            message = Resources.sharedInstance.localizedString(fallbackKey)
        }

        return message
    }
}

struct SimpleEntry: TimelineEntry {
    let date = Date()
    let message: String
}

struct LockScreenTextWidgetEntryView: View {
    var entry: Provider.Entry
    
    var body: some View {

        // Useful for debugging what the size the OS really gives us:
//        GeometryReader { geo in
//            Text("width=\(geo.size.width); height=\(geo.size.height)")
//                .frame(maxWidth: .infinity, maxHeight: .infinity)
//                .border(.black, width: 1.0)
//        }

        LockScreenWidgetContent(message: entry.message)
            .widgetURL(LSConstants.editSettingsNavUrl)
    }
}

@main
struct LockScreenTextWidget: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(
            kind: LSWidgetConstants.kind,
            provider: Provider()
        ) { entry in
            LockScreenTextWidgetEntryView(entry: entry)
        }
        .configurationDisplayName(
            Resources.sharedInstance.localizedString("Widget_DisplayName")
        )
        .description(
            Resources.sharedInstance.localizedString("Widget_Description")
        )
        .supportedFamilies([.accessoryRectangular])
    }
}

// -----------------------------------------------------------------------------

struct LockScreenTextWidget_Previews: PreviewProvider {
    static var previews: some View {
        Group {

            // Short text
            LockScreenTextWidgetEntryView(
                entry: SimpleEntry(
                    message: "If found, please call 01234 567890 or email harry@potter.com"
                )
            )
            .previewContext(WidgetPreviewContext(family: .accessoryRectangular))

            // Long text
            LockScreenTextWidgetEntryView(
                entry: SimpleEntry(
                    message: """
This is a surprisingly long message to see how long text works. \
The quick brown fox jumps over the lazy dog. \
Jackdaws love my big sphinx of quartz.
"""
                )
            )
            .previewContext(WidgetPreviewContext(family: .accessoryRectangular))
        }
    }
}
