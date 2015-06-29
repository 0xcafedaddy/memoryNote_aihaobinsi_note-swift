//
//  NoteTableViewCell.swift
//  Uitest
//
//  Created by brzhang on 15/6/22.
//  Copyright (c) 2015年 brzhang. All rights reserved.
//

import UIKit

class NoteTableViewCell: UITableViewCell {
    
    @IBOutlet weak var noteImage: UIImageView!
    @IBOutlet weak var noteTitle: UILabel!
    @IBOutlet weak var noteAbstract: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
