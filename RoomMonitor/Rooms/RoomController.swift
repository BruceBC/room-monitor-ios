//
//  RoomController.swift
//  RoomMonitor
//
//  Created by Bruce Colby on 7/28/19.
//  Copyright © 2019 Bruce Colby. All rights reserved.
//

import UIKit
import CoreData

protocol RoomControllerDelegate: class {
    func presenceDidChange()
}

class RoomController {
    // MARK: - Constants
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let context     = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // MARK: - Private Properties
    private var sockets = [RoomSocket]()
    
    // MARK: - Properties
    lazy var rooms = fetchRooms()
    weak var delegate: RoomControllerDelegate?
    
    public func closeSockets() {
        sockets.forEach { $0.close() }
        sockets = []
    }
}

// MARK: RoomSocketDelegate
extension RoomController: RoomSocketDelegate {
    func occupied(id: UUID, present: Bool) {
        rooms = rooms.map { room in
            if room.id == id {
                return RoomModel.updatePresence(room: room, occupied: present)
            }
            
            return room
        }
        
        delegate?.presenceDidChange()
    }
    
    func hardwareDisconnected(id: UUID) {
        occupied(id: id, present: false)
    }
    
    func socketDisconnected(id: UUID) {
        occupied(id: id, present: false)
    }
}

// MARK: - Network
extension RoomController {
    func fetchRooms() -> [RoomModel] {
        let request = RoomEntity.fetchRequest() as NSFetchRequest<RoomEntity>
        
        do {
            let rooms = try context.fetch(request).map { RoomModel(id: $0._id, name: $0._name, hardwareId: $0._hardwareId, maxDistance: $0._maxDistance, occupied: false) }
            
            mergeSockets(rooms: rooms)
            
            return rooms
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        return []
    }
    
    func deleteRoom(room: RoomModel) {
        let request = RoomEntity.fetchRequest() as NSFetchRequest<RoomEntity>
        request.predicate = NSPredicate(format: "id == %@", room.id.uuidString)
        
        do {
            let roomEnity = try context.fetch(request).first!
            closeSocket(roomId: roomEnity._id)
            context.delete(roomEnity)
            appDelegate.saveContext()
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
}

// MARK: - Helpers
extension RoomController {
    private func mergeSockets(rooms: [RoomModel]) {
        let existingSockets = rooms.filter { room in
            return sockets.contains(where: { $0.room.id == room.id })
        }.compactMap { room in
            return sockets.first { $0.room.id == room.id }
        }
        
        let newSockets: [RoomSocket] = rooms.filter { room in
            return sockets.first { $0.room.id == room.id } == nil
        }
        .map { room in
            let socket = RoomSocket(room: room)
            socket.delegate = self
            return socket
        }
        
        sockets = existingSockets + newSockets
    }
    
    private func closeSocket(roomId: UUID) {
        sockets = sockets.filter { socket in
            // Close socket
            if socket.room.id == roomId {
                socket.close()
            }
            
            // Remove socket from list
            return socket.room.id != roomId
        }
    }
}
