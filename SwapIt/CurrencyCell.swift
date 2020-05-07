//
//  CurrencyCell.swift
//  SwapIt
//
//  Created by Yao Yu on 5/2/20.
//  Copyright © 2020 FONZIES_LAB. All rights reserved.
//

import UIKit

class CurrencyCell: UITableViewCell {

    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var valuesLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
