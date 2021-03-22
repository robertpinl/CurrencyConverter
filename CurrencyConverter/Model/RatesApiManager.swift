//
//  RatesApiManager.swift
//  CurrencyConverter
//
//  Created by Robert Pinl on 09.01.2021.
//

import UIKit

protocol RatesManagerDelegate {
    func didFailWithError(error: Error)
}

struct  RatesApiManager {
    
    var delegate: RatesManagerDelegate?
    
    func getCurrency(completion: @escaping (RatesData) -> Void) {
        if let url = URL(string: "https://api.exchangeratesapi.io/latest") {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    let decoder = JSONDecoder()
                    do {
                        let rates = try decoder.decode(RatesData.self, from: safeData)
                            completion(rates)
                    } catch {
                        self.delegate?.didFailWithError(error: error)
                    }
                }
            }
            task.resume()
        }
    }
}
