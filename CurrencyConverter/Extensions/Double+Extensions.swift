//
//  Double+Extensions.swift
//  CurrencyConverter
//
//  Created by Robert Pinl on 28.04.2021.
//

import Foundation

extension Double {
    var twoDecimalPlaceString: String {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 0
        let string = formatter.string(from: NSNumber(value: self))
        return string ?? ""
    }
}
