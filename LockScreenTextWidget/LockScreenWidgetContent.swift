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
        (
            Text(Image(decorative: "TextAppIcon")) + Text(message)
        )
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .fontWeight(.medium)
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
