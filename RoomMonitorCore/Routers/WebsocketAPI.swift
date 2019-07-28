//
//  WebsocketAPI.swift
//  RoomMonitorCore
//
//  Created by Bruce Colby on 7/27/19.
//  Copyright © 2019 Bruce Colby. All rights reserved.
//

import Foundation

enum WebsocketAPI {
    case pair(hardwareId: String)
    case setMax(max: Int)
    case getMonitor
    
    var parameters: [String: Any] {
        switch self {
        case .pair(let hardwareId):
            return [
                "hardware_id": hardwareId,
                "type": "pair"
            ]
        case .setMax(let max):
            return [
                "max": max,
                "type": "max"
            ]
        case .getMonitor:
            return [
                "type": "monitor"
            ]
        }
    }
    
    func asJsonStringRequest() -> String {
        guard
            let data = try? JSONSerialization.data(withJSONObject: parameters, options: []),
            let text = String(data: data, encoding: .utf8)
        else { return "" }
        
        return text
    }
}
