//
//  WebsocketResponse.swift
//  RoomMonitorCore
//
//  Created by Bruce Colby on 7/27/19.
//  Copyright © 2019 Bruce Colby. All rights reserved.
//

import Foundation

public struct WebsocketMessageResponse: Codable {
    public let status:     String
    public let statusCode: Int
    public let message:    String
    public let type:       String
}
