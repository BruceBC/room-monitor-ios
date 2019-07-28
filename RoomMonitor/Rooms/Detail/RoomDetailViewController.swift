//
//  ViewController.swift
//  RoomMonitor
//
//  Created by Bruce Colby on 7/26/19.
//  Copyright © 2019 Bruce Colby. All rights reserved.
//

import UIKit
import AnyCodable
import RoomMonitorCore

class RoomDetailViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var hardwareConnectionIndicatorView: UIView!
    @IBOutlet weak var websocketConnectedIndicatorView: UIView!
    @IBOutlet weak var occupiedIndicatorView: UIView!
    
    // MARK: - Private Properties
    private var interactor: WebsocketInteractor!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigation()
        setupViews()
        setupInteractor()
    }
    
    // MARK: - IBActions
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true)
    }
}

// MARK: - Setup
extension RoomDetailViewController {
    func setupNavigation() {
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func setupViews() {
        hardwareConnectionIndicatorView.layer.cornerRadius = 10
        websocketConnectedIndicatorView.layer.cornerRadius = 10
        occupiedIndicatorView.layer.cornerRadius           = 10
    }
    
    func setupInteractor() {
        interactor = WebsocketInteractor(url: "ws://localhost:4040/app", delegate: self)
    }
}

// MARK: - UI
extension RoomDetailViewController {
    func displayMonitor(monitor: Monitor?) {
        guard let monitor = monitor else { return }
        occupiedIndicatorView.backgroundColor = monitor.present ? .green : .red
    }
}

// MARK: WebsocketInteractorDelegate
extension RoomDetailViewController: WebsocketInteractorDelegate {
    func connected() {
        print("Connected")
        websocketConnectedIndicatorView.backgroundColor = .green
    }
    
    func disconnected() {
        print("Disconnected")
        hardwareConnectionIndicatorView.backgroundColor = .red
        websocketConnectedIndicatorView.backgroundColor = .red
        occupiedIndicatorView.backgroundColor           = .red
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

// MARK: Websocket Router
extension RoomDetailViewController {
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
            displayMonitor(monitor: Monitor.decode(response: response))
            getMonitor()
        default:
            print("Unkown type")
        }
    }
    
    func pair() {
        interactor.pair(hardwareId: "50e90b91c72a8a6531900e6c0b842ef3")
    }
    
    func setMax() {
        interactor.setMax(max: 80)
    }
    
    func getMonitor() {
        // Short delay before fetching again
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.interactor.getMonitor()
        }
    }
    
    func hardwareConnected() {
        hardwareConnectionIndicatorView.backgroundColor = .green
    }
    
    func hardwareDisconnected() {
        hardwareConnectionIndicatorView.backgroundColor = .red
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