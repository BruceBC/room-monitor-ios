//
//  Constants.swift
//  RoomMonitor
//
//  Created by Bruce Colby on 7/28/19.
//  Copyright © 2019 Bruce Colby. All rights reserved.
//

import Foundation

// MARK: - Websocket Urls
struct Urls {
    static let local = Env.local
    static let prod  = Env.prod
    static let current = Urls.prod
}

// MARK: - Storyboard Identifiers
struct Identifiers {
    static let rooms      = "RoomsStoryboard"
    static let roomDetail = "RoomDetailViewController"
    static let roomEdit   = "RoomEditViewController"
}
