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
    
    // MARK: - Constants
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let context     = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // MARK: - Properties
    lazy var rooms = fetchRooms()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigation()
        setupTableView()
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
}

// MARK: - TableView
extension RoomsViewController: UITableViewDataSource, UITableViewDelegate {
    var roomReuseIdentifier: String {
        return "room"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rooms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: roomReuseIdentifier, for: indexPath) as! RoomCell
        cell.setup(with: rooms[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: Identifiers.roomEdit, sender: rooms[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteRoom(room: rooms[indexPath.row])
            rooms = fetchRooms()
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}

// MARK: - RoomEditViewControllerDelegate
extension RoomsViewController: RoomEditViewControllerDelegate {
    func saved() {
        let range = NSMakeRange(0, tableView.numberOfSections)
        let sections = NSIndexSet(indexesIn: range)
        
        rooms = fetchRooms()
        tableView.reloadSections(sections as IndexSet, with: .automatic)
    }
}

// MARK: - Network
extension RoomsViewController {
    func fetchRooms() -> [RoomModel] {
        let request = RoomEntity.fetchRequest() as NSFetchRequest<RoomEntity>
        
        do {
            return try context.fetch(request).map { RoomModel(id: $0._id, name: $0._name, hardwareId: $0._hardwareId, maxDistance: $0._maxDistance, occupied: false) }
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
            context.delete(roomEnity)
            appDelegate.saveContext()
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
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
