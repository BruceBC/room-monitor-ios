//
//  Env.swift
//  RoomMonitor
//
//  Created by Bruce Colby on 7/30/19.
//  Copyright © 2019 Bruce Colby. All rights reserved.
//
// Resources: https://learnappmaking.com/plist-property-list-swift-how-to/

import Foundation

// MARK: - Fetches items from Env.plist
struct Env {
    static let local = EnvironmentDecoder.env()?.local ?? ""
    static let prod  = EnvironmentDecoder.env()?.prod  ?? ""
}
