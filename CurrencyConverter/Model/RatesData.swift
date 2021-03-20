//
//  RatesData.swift
//  CurrencyConverter
//
//  Created by Robert P on 09.01.2021.
//

import Foundation

struct RatesData: Codable {
    let rates: [String: Double]
}

//let currency = ["AUD", "BGN", "BRL", "CAD", "CHF", "CNY", "CZK", "DKK", "GBP", "HKD", "HRK", "HUF", "IDR", "ILS", "INR", "ISK", "JPY", "KRW", "MXN", "MYR", "NOK", "NZD", "PHP", "PLN", "RON", "RUB", "SEK", "SGD", "THB", "TRY", "USD", "ZAR"]
