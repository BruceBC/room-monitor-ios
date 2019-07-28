//
//  RoomSocket.swift
//  RoomMonitor
//
//  Created by Bruce Colby on 7/28/19.
//  Copyright © 2019 Bruce Colby. All rights reserved.
//

import Foundation
import AnyCodable
import RoomMonitorCore

protocol RoomSocketDelegate: class {
    func occupied(id: UUID, present: Bool)
}

class RoomSocket {
    // MARK: - Public Properties
    let room: RoomModel
    
    // MARK: - Private Properties
    private var interactor: WebsocketInteractor!
    
    // MARK: - Weak Properties
    weak var delegate: RoomSocketDelegate?
    
    init(room: RoomModel) {
        self.room = room
        
        // Setup
        setupInteractor()
    }
}

// MARK: - Setup
extension RoomSocket {
    private func setupInteractor() {
        interactor = WebsocketInteractor(url: Urls.current, delegate: self)
    }
}

// MARK: - Monitor
extension RoomSocket {
    private func report(monitor: Monitor?) {
        guard let monitor = monitor else { return }
        delegate?.occupied(id: room.id, present: monitor.present)
    }
}

// MARK: WebsocketInteractorDelegate
extension RoomSocket: WebsocketInteractorDelegate {
    func connected() {}
    
    func disconnected() {
        delegate?.occupied(id: room.id, present: false)
    }
    
    func received(result: Result<WebsocketMessageResponse, Error>) {
        switch result {
        case .success(let response):
            print(response)
            route(response: response)
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
    
    func received(result: Result<WebsocketDataResponse, Error>) {
        switch result {
        case .success(let response):
            print(response)
            route(response: response)
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
}

// MARK: - Websocket Router
extension RoomSocket {
    func route(response: WebsocketMessageResponse) {
        switch response.type {
        case "ready":
            pair()
        case "paired":
            setMax()
        case "max":
            getMonitor()
        case "connected":
            hardwareConnected()
        case "disconnected":
            hardwareDisconnected()
        case "process_not_started":
            processNotStarted()
        case "error":
            error(message: response.message)
        default:
            print("Unkown type")
        }
    }
    
    func route(response: WebsocketDataResponse) {
        switch response.type {
        case "monitor":
            report(monitor: Monitor.decode(response: response))
            getMonitor()
        default:
            print("Unkown type")
        }
    }
    
    func pair() {
        interactor.pair(hardwareId: room.hardwareId)
    }
    
    func setMax() {
        interactor.setMax(max: room.maxDistance)
    }
    
    func getMonitor() {
        // Short delay before fetching again
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.interactor.getMonitor()
        }
    }
    
    func hardwareConnected() {}
    
    func hardwareDisconnected() {
        delegate?.occupied(id: room.id, present: false)
    }
    
    func processNotStarted() {
        // Hardware not yet connected, need to try to update max again.
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.setMax()
        }
    }
    
    func error(message: String) {
        print("error: \(message)")
    }
}
