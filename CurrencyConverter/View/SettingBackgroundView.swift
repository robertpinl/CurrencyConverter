//
//  SettingBackgroundView.swift
//  CurrencyConverter
//
//  Created by Robert P on 21.03.2021.
//

import UIKit

class SettingBackgroundView: UIView {

    override func awakeFromNib() {
        layer.cornerRadius = 12
        layer.borderWidth = 0.8
        layer.borderColor = UIColor(named: "outlineColor")?.cgColor
        layer.backgroundColor = UIColor(named: "convertViewColor")?.cgColor
    }
}
