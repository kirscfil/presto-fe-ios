//
//  MenuItemCell.swift
//  PrestoMenu
//
//  Created by Filip Kirschner on 15/03/2018.
//  Copyright © 2018 Applifting. All rights reserved.
//

import UIKit

class MenuItemCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!

    static let reuseIdentifier = "MenuItemCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        nameLabel.text = ""
        priceLabel.text = ""
    }
    
}
