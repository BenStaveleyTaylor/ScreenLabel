//
//  LockScreenTextWidget.swift
//  LockScreenTextWidget
//
//  Created by Ben Staveley-Taylor on 23/10/2022.
//  Copyright © 2022 Ben Staveley-Taylor. All rights reserved.
//

import WidgetKit
import SwiftUI
import LockScreenTextExtensionFramework

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(
            date: Date(),
            message: "Your contact information is shown here"
        )
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        let entry = SimpleEntry(
            date: Date(),
            message: "If found, contact harry@potter.com (+44 1234 567890)"
        )
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        let entry = SimpleEntry(
            date: Date(),
            message: "If found, contact harry@potter.com (+44 1234 567890)"
        )
        let entries: [SimpleEntry] = [entry]

        let timeline = Timeline(entries: entries, policy: .never)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let message: String
}

struct LockScreenTextWidgetEntryView: View {
    var entry: Provider.Entry

    var body: some View {
        Text(entry.message)
//        Text(entry.date, style: .time)
    }
}

@main
struct LockScreenTextWidget: Widget {
    let kind: String = "LockScreenTextWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            LockScreenTextWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Screen Label")
        .description("Display the contact information set in the Screen Label app")
        .supportedFamilies([.accessoryRectangular])
    }
}

struct LockScreenTextWidget_Previews: PreviewProvider {
    static var previews: some View {
        LockScreenTextWidgetEntryView(entry: SimpleEntry(
            date: Date(),
            message: "If found, contact harry@potter.com (+44 1234 567890)")
        )
            .previewContext(WidgetPreviewContext(family: .accessoryRectangular))
    }
}
