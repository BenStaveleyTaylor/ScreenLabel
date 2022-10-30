//
//  DeepLinkHandler.swift
//  LockScreenText
//
//  Created by Ben Staveley-Taylor on 05/11/2022.
//  Copyright © 2022 Ben Staveley-Taylor. All rights reserved.
//

import Foundation
import os.log

public class DeepLinkHandler {

    public typealias LinkHandler = ((String) -> Void)

    private var links: [String: LinkHandler] = [:]

    private var pendingLinkEvents = Set<String>()

    /// The shared handler used when handling a deep link.
    public static var shared = DeepLinkHandler()

    // Example of link: "editsettings"
    public func registerLink(_ link: String, handler: @escaping LinkHandler) {
        links[link] = handler
        if pendingLinkEvents.contains(link) {
            os_log("Handling deferred link: %@", link)
            pendingLinkEvents.remove(link)
            handler(link)
        }
    }

    // Example of link: "editsettings"
    public func unregisterLink(_ link: String) {
        links.removeValue(forKey: link)
    }

    // This handles the link if any handlers are registers, or else
    // stores it and if a handler is registered later then it is handled then.
    public func handleLink(_ link: String) {
        if let handler = links[link] {
            // We have a hander, execute immediately
            os_log("Handling link: %@", link)
            handler(link)
        }
        else {
            os_log("Deferring handling for link: %@", link)
            pendingLinkEvents.insert(link)
        }
    }

    // -------------------------------------------------------------------------

    // No public instantiation -- access through `shared`
    private init() {}
}
