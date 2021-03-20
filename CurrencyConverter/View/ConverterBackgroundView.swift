//
//  ConverterBackgroundView.swift
//  CurrencyConverter
//
//  Created by Robert P on 20.03.2021.
//

import UIKit

class ConverterBackgroundView: UIView {
    
    override func awakeFromNib() {
        layer.cornerRadius = bounds.height / 2
        layer.borderWidth = 1
        layer.borderColor = UIColor(named: "outlineColor")?.cgColor
            }
    
}
