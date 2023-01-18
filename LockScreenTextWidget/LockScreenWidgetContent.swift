//
//  LockScreenWidgetContent.swift
//  LockScreenText
//
//  Created by Ben Staveley-Taylor on 09/12/2022.
//  Copyright © 2022 Ben Staveley-Taylor. All rights reserved.
//

import SwiftUI

@available(iOS 16, *)
struct LockScreenWidgetContent: View {
    var message: String

    var body: some View {

        // Useful for debugging what the size the OS really gives us:
//        GeometryReader { geo in
//            Text("width=\(geo.size.width); height=\(geo.size.height)")
//                .frame(maxWidth: .infinity, maxHeight: .infinity)
//                .border(.black, width: 1.0)
//        }

        // The font size is not clear. 15 is my best guess.
        (
            Text(Image(decorative: "TextAppIcon")) + Text(message)
        )
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .font(.system(size: 15, weight: .medium))
        .allowsTightening(true)
        .minimumScaleFactor(2.0/3.0)
    }
}

@available(iOS 16, *)
struct LockScreenWidgetContent_Previews: PreviewProvider {
    static var previews: some View {
        LockScreenWidgetContent(message: "Jackdaws love my big sphinx of quartz")
    }
}
