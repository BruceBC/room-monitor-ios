//
//  Monitor.swift
//  RoomMonitorCore
//
//  Created by Bruce Colby on 7/27/19.
//  Copyright © 2019 Bruce Colby. All rights reserved.
//

import Foundation

//%Monitor.State{distance: 63, max: 80, min: 19, present: true}
public struct Monitor: Codable {
    public let distance: Int
    public let max:      Int
    public let min:      Int
    public let present:  Bool
}

// MARK: - Decode
extension Monitor {
    public static func decode(response: WebsocketDataResponse) -> Monitor? {
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        
        guard
            let data = try? encoder.encode(response.data),
            let monitor = try? decoder.decode(Monitor.self, from: data)
            else { return nil }
        
        return monitor
    }
}
