//
//  ValidateDouble+Extension.swift
//  CurrencyConverter
//
//  Created by Robert Pinl on 21.03.2021.
//

import Foundation

extension String {
  func isValidDouble(maxDecimalPlaces: Int) -> Bool {

    let formatter = NumberFormatter()
    formatter.allowsFloats = true
    let decimalSeparator = formatter.decimalSeparator ?? "."

    if formatter.number(from: self) != nil {
      let split = self.components(separatedBy: decimalSeparator)

      let digits = split.count == 2 ? split.last ?? "" : ""

      return digits.count <= maxDecimalPlaces
    }
    return false
  }
}
