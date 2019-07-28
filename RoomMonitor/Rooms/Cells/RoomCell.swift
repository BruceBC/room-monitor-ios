//
//  RoomCell.swift
//  RoomMonitor
//
//  Created by Bruce Colby on 7/28/19.
//  Copyright © 2019 Bruce Colby. All rights reserved.
//

import UIKit

class RoomCell: UITableViewCell {
    @IBOutlet weak var roomNameLabel: UILabel!
    @IBOutlet weak var occupiedIndicatorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupViews()
    }
}

extension RoomCell {
    func setup(with model: RoomModel) {
        roomNameLabel.text = model.name
        occupiedIndicatorView.backgroundColor = model.occupied ? .green : .red
    }
    
    func setupViews() {
        occupiedIndicatorView.layer.cornerRadius = 10
    }
}
