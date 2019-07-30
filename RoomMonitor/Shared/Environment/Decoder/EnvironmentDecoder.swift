//
//  EnvironmentDecoder.swift
//  RoomMonitor
//
//  Created by Bruce Colby on 7/30/19.
//  Copyright © 2019 Bruce Colby. All rights reserved.
//

import Foundation

struct EnvironmentDecoder {
    static func env() -> Environment? {
        guard
            let path = Bundle.main.path(forResource: "Env", ofType: "plist"),
            let xml = FileManager.default.contents(atPath: path),
            let env = try? PropertyListDecoder().decode(Environment.self, from: xml)
        else { return nil }
        
        return env
    }
}
