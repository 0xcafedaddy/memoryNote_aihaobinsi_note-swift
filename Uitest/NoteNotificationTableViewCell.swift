//
//  NoteNotificationTableViewCell.swift
//  Uitest
//
//  Created by brzhang on 15/6/25.
//  Copyright (c) 2015年 brzhang. All rights reserved.
//

import UIKit

class NoteNotificationTableViewCell: UITableViewCell {

    @IBOutlet weak var notificationTimeTitle: UILabel!
    @IBOutlet weak var notificationTimeData: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
