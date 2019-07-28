//
//  WebsocketInteractor.swift
//  RoomMonitorCore
//
//  Created by Bruce Colby on 7/27/19.
//  Copyright © 2019 Bruce Colby. All rights reserved.
//

import Foundation
import Starscream

public protocol WebsocketInteractorDelegate: class {
    func connected()
    func disconnected()
    func received(result: Result<WebsocketMessageResponse, Error>)
    func received(result: Result<WebsocketDataResponse, Error>)
}

public class WebsocketInteractor: WebsocketService {
    private var url: String
    private var socket: WebSocket?
    private weak var delegate: WebsocketInteractorDelegate?
    
    public init(url: String, delegate: WebsocketInteractorDelegate?) {
        self.url      = url
        self.delegate = delegate
        
        connect()
    }
    
    public func pair(hardwareId: String) {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        socket?.write(string: WebsocketAPI.pair(hardwareId: hardwareId).asJsonStringRequest())
    }
    
    public func setMax(max: Int) {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        socket?.write(string: WebsocketAPI.setMax(max: max).asJsonStringRequest())
    }
    
    public func getMonitor() {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        socket?.write(string: WebsocketAPI.getMonitor.asJsonStringRequest())
    }
}

// MARK: - Setup
extension WebsocketInteractor {
    private func connect() {
        guard let url = URL(string: url) else { return }
        
        socket = WebSocket(url: url)
        socket?.delegate = self
        socket?.connect()
    }
}

extension WebsocketInteractor: WebSocketDelegate {
    public func websocketDidConnect(socket: WebSocketClient) {
        delegate?.connected()
    }
    
    public func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        delegate?.disconnected()
        
        // Reconnect
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.connect()
        }
    }
    
    public func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        decode(text: text, decoder: decoder)
    }
    
    public func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        print("Received \(data.count)")
    }
}

extension WebsocketInteractor {
    private func decode(text: String, decoder: JSONDecoder) {
        do {
            let response = try decoder.decode(WebsocketMessageResponse.self, from: Data(text.utf8))
            delegate?.received(result: .success(response))
        } catch {
            tryToRecover(text: text, decoder: decoder)
        }
    }
    
    private func tryToRecover(text: String, decoder: JSONDecoder) {
        do {
            let response = try decoder.decode(WebsocketDataResponse.self, from: Data(text.utf8))
            delegate?.received(result: .success(response))
        } catch {
            delegate?.received(result: Result<WebsocketDataResponse, Error>.failure(error))
        }
    }
}
