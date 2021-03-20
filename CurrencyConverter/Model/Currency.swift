//
//  Currency.swift
//  CurrencyConverter
//
//  Created by Robert P on 19.03.2021.
//

import UIKit

struct Currency {
    let name: String
    let rate: Double
    
    var flag: String {
        switch name {
        case "CAD":
            return "🇨🇦"
        case "HKD":
            return "🇨🇳"
        case "ISK":
            return "🇮🇸"
        case "PHP":
            return "🇵🇭"
        case "DKK":
            return "🇩🇰"
        case "HUF":
            return "🇭🇺"
        case "CZK":
            return "🇨🇿"
        case "AUD":
            return "🇦🇺"
        case "RON":
            return "🇷🇴"
        case "SEK":
            return "🇸🇪"
        case "IDR":
            return "🇮🇩"
        case "INR":
            return "🇮🇳"
        case "BRL":
            return "🇧🇷"
        case "RUB":
            return "🇷🇺"
        case "HRK":
            return "🇭🇷"
        case "JPY":
            return "🇯🇵"
        case "THB":
            return "🇹🇭"
        case "CHF":
            return "🇨🇭"
        case "SGD":
            return "🇲🇾"
        case "PLN":
            return "🇵🇱"
        case "BGN":
            return "🇧🇬"
        case "TRY":
            return "🇹🇷"
        case "CNY":
            return "🇨🇳"
        case "NOK":
            return "🇳🇴"
        case "NZD":
            return "🇳🇿"
        case "ZAR":
            return "🇸🇸"
        case "USD":
            return "🇺🇸"
        case "MXN":
            return "🇲🇽"
        case "ILS":
            return "🇮🇱"
        case "GBP":
            return "🇬🇧"
        case "KRW":
            return "🇰🇷"
        case "MYR":
            return "🇲🇾"
        case "EUR":
            return "🇪🇺"
        default:
            return ""
        }
    }
}

