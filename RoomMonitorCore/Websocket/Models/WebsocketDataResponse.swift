//
//  WebsocketDataResponse.swift
//  RoomMonitorCore
//
//  Created by Bruce Colby on 7/27/19.
//  Copyright © 2019 Bruce Colby. All rights reserved.
//

import Foundation
import AnyCodable

public struct WebsocketDataResponse: Codable {
    public let status:     String
    public let statusCode: Int
    public let data:       AnyCodable
    public let type:       String
}
