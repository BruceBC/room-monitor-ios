//
//  RoomModel.swift
//  RoomMonitor
//
//  Created by Bruce Colby on 7/28/19.
//  Copyright © 2019 Bruce Colby. All rights reserved.
//

import Foundation

struct RoomModel {
    let id:          UUID
    let name:        String
    let hardwareId:  String
    let maxDistance: Int
    let occupied:    Bool
}
