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

    struct LinkHandlerInfo {
        let handler: LinkHandler
        var enabled: Bool
    }

    private var links: [String: LinkHandlerInfo] = [:]

    private var pendingLinkEvents = Set<String>()

    /// The shared handler used when handling a deep link.
    public static var shared = DeepLinkHandler()

    // Example of link: "editsettings"
    // This will replace any existing handler
    public func registerLink(_ link: String, handler: @escaping LinkHandler) {
        let info = LinkHandlerInfo(handler: handler, enabled: true)
        links[link] = info
        // Catch up on links sent before we registered
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

    // Allow a handler to be disabled without removing it
    public func setLinkEnabled(_ link: String, enabled: Bool) {
        var info = links[link]
        info?.enabled = enabled
        links[link] = info
    }

    // This handles the link if any handlers are registers, or else
    // stores it and if a handler is registered later then it is handled then.
    public func handleLink(_ link: String) {
        if let info = links[link] {
            // We have a hander, execute immediately
            if info.enabled {
                os_log("Handling link: %@", link)
                info.handler(link)
            } else {
                os_log("Handler disabled for link: %@", link)
            }
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
