//
//  RoomsViewController.swift
//  RoomMonitor
//
//  Created by Bruce Colby on 7/26/19.
//  Copyright © 2019 Bruce Colby. All rights reserved.
//

import UIKit
import CoreData

class RoomsViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    lazy var controller = RoomController()
    var indexPathToBeDeleted: IndexPath?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigation()
        setupTableView()
        setupController()
    }
    
    // MARK: - IBActions
    @IBAction func addRoom(_ sender: Any) {
        performSegue(withIdentifier: Identifiers.roomEdit, sender: self)
    }
}

// MARK: - Setup
extension RoomsViewController {
    func setupNavigation() {
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func setupTableView() {
        tableView.tableFooterView = UIView()
    }
    
    func setupController() {
        controller.delegate = self
    }
}

// MARK: - TableView
extension RoomsViewController: UITableViewDataSource, UITableViewDelegate {
    var roomReuseIdentifier: String {
        return "room"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return controller.rooms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: roomReuseIdentifier, for: indexPath) as! RoomCell
        cell.setup(with: controller.rooms[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: Identifiers.roomEdit, sender: controller.rooms[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            controller.deleteRoom(room: controller.rooms[indexPath.row])
            controller.rooms = controller.fetchRooms()
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    // Swipe left for delete
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        indexPathToBeDeleted = indexPath
        return nil
    }
}

// MARK: - RoomControllerDelegate
extension RoomsViewController: RoomControllerDelegate {
    func refresh() {
        guard let indexPaths = tableView.indexPathsForVisibleRows else { return }
        
        indexPaths.forEach { indexPath in
            if let cell = tableView.cellForRow(at: indexPath) as? RoomCell {
                cell.setup(with: self.controller.rooms[indexPath.row])
            }
        }
    }
}

// MARK: - RoomEditViewControllerDelegate
extension RoomsViewController: RoomEditViewControllerDelegate {
    func saved() {
        let range = NSMakeRange(0, tableView.numberOfSections)
        let sections = NSIndexSet(indexesIn: range)
        
        controller.rooms = controller.fetchRooms()
        tableView.reloadSections(sections as IndexSet, with: .automatic)
    }
}

// MARK: - Navigation
extension RoomsViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Create Room
        if let _ = sender as? RoomsViewController, segue.identifier == Identifiers.roomEdit {
            let nav = segue.destination as! UINavigationController
            let vc  = nav.topViewController as! RoomEditViewController
            
            vc.delegate = self
        }
        
        // Edit Room
        if let room = sender as? RoomModel, segue.identifier == Identifiers.roomEdit {
            let nav = segue.destination as! UINavigationController
            let vc  = nav.topViewController as! RoomEditViewController
            let _   = vc.view // Ensure view is loaded
            
            vc.setup(with: room)
            vc.delegate = self
        }
    }
}
