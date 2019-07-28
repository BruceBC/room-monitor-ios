//
//  RoomEntity+CoreDataClass.swift
//  RoomMonitor
//
//  Created by Bruce Colby on 7/28/19.
//  Copyright © 2019 Bruce Colby. All rights reserved.
//

import Foundation
import CoreData

public class RoomEntity: NSManagedObject {
    
}

// MARK: - Concrete
extension RoomEntity {
    var _id: UUID {
        return id!
    }
    
    var _name: String {
        return name!
    }
    
    var _hardwareId: String {
        return hardwareId!
    }
    
    var _maxDistance: Int {
        return Int(maxDistance)
    }
}
