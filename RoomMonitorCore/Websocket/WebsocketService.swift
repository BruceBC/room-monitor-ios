//
//  WebsocketService.swift
//  RoomMonitorCore
//
//  Created by Bruce Colby on 7/27/19.
//  Copyright © 2019 Bruce Colby. All rights reserved.
//

import Foundation
import Starscream

public protocol WebsocketService {
    func pair(hardwareId: String)
    func setMax(max: Int)
    func ping()
}
