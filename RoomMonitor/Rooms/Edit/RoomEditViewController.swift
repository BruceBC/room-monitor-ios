//
//  RoomEditViewController.swift
//  RoomMonitor
//
//  Created by Bruce Colby on 7/28/19.
//  Copyright © 2019 Bruce Colby. All rights reserved.
//

import UIKit

protocol RoomEditViewControllerDelegate: class {
    func saved()
}

class RoomEditViewController: UITableViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var roomNameTextField:    UITextField!
    @IBOutlet weak var hardwareIdTextField:  UITextField!
    @IBOutlet weak var maxDistanceTextField: UITextField!
    
    // MARK: - Constants
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let context     = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // MARK: - Properties
    weak var delegate: RoomEditViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigation()
        setupTableView()
    }
    
    // MARK: - IBActions
    @IBAction func save(_ sender: Any) {
        save()
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true)
    }
}

// MARK: - Setup
extension RoomEditViewController {
    func setupNavigation() {
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func setupTableView() {
        tableView.tableFooterView = UIView()
    }
}

// MARK: - TableView
extension RoomEditViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 497
    }
}

// MARK: Helpers
extension RoomEditViewController {
    private func save() {
        guard
            let name              = roomNameTextField.text,
            let hardwareId        = hardwareIdTextField.text,
            let maxDistanceString = maxDistanceTextField.text,
            let maxDistance       = Int32(maxDistanceString)
        else { return }
        
        let roomEntity  = RoomEntity(context: context)
        
        roomEntity.name = name
        roomEntity.hardwareId = hardwareId
        roomEntity.maxDistance = Int32(maxDistance)
        
        appDelegate.saveContext()
        
        dismiss(animated: true) {
            self.delegate?.saved()
        }
    }
}
