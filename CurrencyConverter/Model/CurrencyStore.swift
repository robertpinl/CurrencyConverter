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

//class DataManipulation {
//    static private var plistURL: URL {
//        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//        return documents.appendingPathComponent("OfflineData.plist")
//    }
//
//    static func load() -> [Currency] {
//        let decoder = PropertyListDecoder()
//
//        guard let data = try? Data.init(contentsOf: plistURL),
//              let currency = try? decoder.decode(Currency.self, from: data)
//        else { return [] }
//
//        print(currency)
//
//        return [currency]
//    }
//}
//
//extension DataManipulation {
//    static func save() {
//        let encoder = PropertyListEncoder()
//
//        if let data = try? encoder.encode(CurrencyStore.shared.currencies) {
//            if FileManager.default.fileExists(atPath: plistURL.path) {
//                // Update an existing plist
//                try? data.write(to: plistURL)
//                print("Saved!")
//            } else {
//                // Create a new plist
//                FileManager.default.createFile(atPath: plistURL.path, contents: data, attributes: nil)
//                print("Saved!")
//            }
//        }
//    }
//}
