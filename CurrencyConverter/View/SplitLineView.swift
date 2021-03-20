//
//  SplitLineView.swift
//  CurrencyConverter
//
//  Created by Robert Pinl on 20.03.2021.
//

import UIKit

class SplitLineView: UIView {

    override  func awakeFromNib() {
        layer.cornerRadius = bounds.width / 2
        layer.backgroundColor = UIColor(named: "outlineColor")?.cgColor
    }
}
