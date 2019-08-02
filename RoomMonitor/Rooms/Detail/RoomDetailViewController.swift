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

class RoomDetailViewController: UITableViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var hardwareConnectionIndicatorView: UIView!
    @IBOutlet weak var websocketConnectedIndicatorView: UIView!
    @IBOutlet weak var occupiedIndicatorView: UIView!
    
    // MARK: - Private Properties
    private var socket: RoomSocket?
    
    // MARK: - Public Properties
    var room: RoomModel?
    weak var dismissalDelgate: DismissalDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigation()
        setupViews()
        setupTableView()
        setupSocket()
    }
    
    // MARK: - IBActions
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true) {
            self.socket?.close()
            self.dismissalDelgate?.didDismiss()
        }
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
    
    func setupSocket() {
        guard let room = room else { return }
        
        socket           = RoomSocket(room: room)
        socket?.delegate = self
    }
    
    func setupTableView() {
        tableView.tableFooterView = UIView()
    }
}

// MARK: RoomSocketDelegate
extension RoomDetailViewController: RoomSocketDelegate {
    func occupied(id: UUID, present: Bool) {
        occupiedIndicatorView.backgroundColor = present ? .green : .red
    }
    
    func hardwareConnected(id: UUID) {
        hardwareConnectionIndicatorView.backgroundColor = .green
    }
    
    func hardwareDisconnected(id: UUID) {
        hardwareConnectionIndicatorView.backgroundColor = .red
        occupiedIndicatorView.backgroundColor           = .red
    }
    
    func socketConnected(id: UUID) {
        websocketConnectedIndicatorView.backgroundColor = .green
    }
    
    func socketDisconnected(id: UUID) {
        hardwareConnectionIndicatorView.backgroundColor = .red
        websocketConnectedIndicatorView.backgroundColor = .red
        occupiedIndicatorView.backgroundColor           = .red
    }
}

// MARK: - TableView
extension RoomDetailViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 490
    }
}
