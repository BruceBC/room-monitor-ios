//
//  SettingCell.swift
//  RoomMonitor
//
//  Created by Bruce Colby on 7/27/19.
//  Copyright © 2019 Bruce Colby. All rights reserved.
//

import UIKit

class SettingCell: UITableViewCell {
    // MARK: - IBOutlets
    @IBOutlet weak var titleLabel: UILabel!
}

extension SettingCell {
    func setup(with model: SettingModel) {
        titleLabel.text = model.title
    }
}
