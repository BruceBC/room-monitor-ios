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
    let settings = [
        SettingModel(title: "Rooms"),
        SettingModel(title: "Wifi")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigation()
        setupTableView()
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
}
