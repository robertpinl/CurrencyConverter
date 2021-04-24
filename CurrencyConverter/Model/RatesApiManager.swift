//
//  RatesApiManager.swift
//  CurrencyConverter
//
//  Created by Robert Pinl on 09.01.2021.

import UIKit

protocol RatesManagerDelegate {
    func didFailWithError(error: Error)
}

struct  RatesApiManager {
    
    static let shared = RatesApiManager()
    
    var delegate: RatesManagerDelegate?
        
    func getRates(url: URL?, completion: @escaping (RatesData) -> Void) {
        if let url = url {
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
                        DispatchQueue.main.async {
                            completion(rates)
                        }
                    } catch {
                        self.delegate?.didFailWithError(error: error)
                    }
                }
            }
            task.resume()
        }
    }
    
    func getSymbols(url: URL?, completion: @escaping (SymbolsData) -> Void) {
        if let url = url {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    let decoder = JSONDecoder()
                    do {
                        let symbols = try decoder.decode(SymbolsData.self, from: safeData)
                            completion(symbols)
                    } catch {
                        self.delegate?.didFailWithError(error: error)
                    }
                }
            }
            task.resume()
        }
    }
}
