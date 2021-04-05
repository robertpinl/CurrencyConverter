//
//  CurrencyRateTableViewCell.swift
//  CurrencyConverter
//
//  Created by Robert Pinl on 05.04.2021.
//

import UIKit

class CurrencyRateTableViewCell: UITableViewCell {

    @IBOutlet weak var flagLabel: UILabel!
    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
