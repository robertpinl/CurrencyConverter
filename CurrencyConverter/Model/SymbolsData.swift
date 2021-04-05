//
//  SymbolsData.swift
//  CurrencyConverter
//
//  Created by Robert P on 04.04.2021.
//

import Foundation

struct SymbolsData: Codable {
    let success: Bool
    let symbols: [String: Symbol]
}

struct Symbol: Codable {
    let description: String
    let code: String
}
