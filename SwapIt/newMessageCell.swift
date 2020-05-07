//
//  newMessageCell.swift
//  SwapIt
//
//  Created by Yao Yu on 5/4/20.
//  Copyright © 2020 FONZIES_LAB. All rights reserved.
//

import UIKit

class newMessageCell: UITableViewCell {

    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var lastNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
