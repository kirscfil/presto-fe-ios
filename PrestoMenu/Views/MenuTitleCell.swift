//
//  MenuTitleCell.swift
//  PrestoMenu
//
//  Created by Filip Kirschner on 15/03/2018.
//  Copyright © 2018 Applifting. All rights reserved.
//

import UIKit

class MenuTitleCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    
    static let reuseIdentifier = "MenuTitleCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
