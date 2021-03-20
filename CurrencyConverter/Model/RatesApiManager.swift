//
//  RatesApiManager.swift
//  CurrencyConverter
//
//  Created by Robert P on 09.01.2021.
//

import Foundation

struct  RatesApiManager {
    
    func getCurrency(completion: @escaping (RatesData) -> Void) {
        if let url = URL(string: K.Url.baseUrl) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                if let safeData = data {
                    let decoder = JSONDecoder()
                    do {
                        let rates = try decoder.decode(RatesData.self, from: safeData)
                            completion(rates)
                    } catch {
                        print(error)
                    }
                }
            }
            task.resume()
        }
    }
}

//struct NewsAPI {
//
//    func fetchAPI(with urlString: String, completion: @escaping ([Articles]) -> Void) {
//        if let url = URL(string: urlString) {
//            let session = URLSession(configuration: .default)
//            let task = session.dataTask(with: url) { (data, response, error) in
//                if error != nil {
//                    print(error.debugDescription)
//                    return
//                }
//                if let safeData = data {
//                    let decoder = JSONDecoder()
//                    do {
//                        let news = try decoder.decode(NewsData.self, from: safeData).articles
//                        completion(news)
//                    } catch {
//                        print(error)
//                    }
//                }
//            }
//            task.resume()
//        }
//    }
//}
