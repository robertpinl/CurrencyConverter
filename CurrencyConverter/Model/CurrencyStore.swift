//
//  CurrencyStore.swift
//  CurrencyConverter
//
//  Created by Robert P on 08.04.2021.
//

import Foundation

class CurrencyStore {
    
    static let shared = CurrencyStore()
    
    var currencies = [Currency]()
}
