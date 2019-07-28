//
//  SettingsViewController.swift
//  RoomMonitor
//
//  Created by Bruce Colby on 7/27/19.
//  Copyright © 2019 Bruce Colby. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Properties
    var settings = [SettingModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigation()
        setupTableView()
        setupModels()
    }
}

// MARK: - Setup
extension SettingsViewController {
    func setupNavigation() {
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func setupTableView() {
        tableView.tableFooterView = UIView()
    }
    
    func setupModels() {
        settings = [
            SettingModel(title: "Rooms", action: {
                self.performSegue(withIdentifier: Identifiers.rooms, sender: self)
            }),
            SettingModel(title: "Wifi", action: {})
        ]
    }
}

// MARK: - TableView
extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    var settingReuseIdentifier: String {
        return "setting"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: settingReuseIdentifier, for: indexPath) as! SettingCell
        cell.setup(with: settings[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        settings[indexPath.row].action()
    }
}

// MARK: - Navigation
extension SettingsViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Identifiers.rooms {
            let vc  = segue.destination as! RoomsViewController
            let _ = vc.view // Must let viewDidLoad occur before setting roomViewType
            
            
            vc.navigationItem.largeTitleDisplayMode = .never
            vc.roomViewType = .edit
        }
    }
}
