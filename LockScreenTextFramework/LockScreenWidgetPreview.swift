//
//  LockScreenWidgetPreview.swift
//  LockScreenTextFramework
//
//  Created by Ben Staveley-Taylor on 09/12/2022.
//  Copyright © 2022 Ben Staveley-Taylor. All rights reserved.
//

import SwiftUI
import os.log

@available(iOS 16, *)
struct LockScreenWidgetPreview: View {
    var message: String

    // In the real LockScreen widget rendition, text is always
    // white on a transparent background. The font size is not
    // clear. 15 is my best guess.
    var body: some View {
        LockScreenWidgetContent(message: message)
            .foregroundColor(.white)
            .background(.clear)
            .font(.system(size: 15))
            .onTapGesture {
                os_log("widget tapped")
            }
    }
}

@available(iOS 16, *)
struct LockScreenWidgetPreview_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color(.red)
            LockScreenWidgetPreview(message: "Jackdaws love my big sphinx of quartz")
        }.frame(width: 155.0, height: 60.0)

    }
}
