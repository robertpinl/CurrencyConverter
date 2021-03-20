//
//  SplitLineView.swift
//  CurrencyConverter
//
//  Created by Robert P on 20.03.2021.
//

import UIKit

class SplitLineView: UIView {

    override  func awakeFromNib() {
        layer.cornerRadius = bounds.width / 2
        layer.borderWidth = 0.5
        layer.borderColor = UIColor(named: "outlineColor")?.cgColor
    }

}
