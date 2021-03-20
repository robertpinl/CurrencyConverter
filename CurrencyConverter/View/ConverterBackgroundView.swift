//
//  ConverterBackgroundView.swift
//  CurrencyConverter
//
//  Created by Robert Pinl on 20.03.2021.
//

import UIKit

class ConverterBackgroundView: UIView {
    
    override func awakeFromNib() {
        layer.cornerRadius = bounds.height / 2
        layer.borderWidth = 0.8
        layer.borderColor = UIColor(named: "outlineColor")?.cgColor
        layer.backgroundColor = UIColor(named: "convertViewColor")?.cgColor
    }
}
