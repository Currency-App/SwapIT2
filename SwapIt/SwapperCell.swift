//
//  SwapperCell.swift
//  SwapIt
//
//  Created by Nanar Boursalian on 5/2/20.
//  Copyright © 2020 FONZIES_LAB. All rights reserved.
//

import UIKit

class SwapperCell: UITableViewCell {

    @IBOutlet weak var firstName: UILabel!
    
    @IBOutlet weak var lastName: UILabel!
    
    @IBOutlet weak var email: UILabel!
    
    @IBOutlet weak var amount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
