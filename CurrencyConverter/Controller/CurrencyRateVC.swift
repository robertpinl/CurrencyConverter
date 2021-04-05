//
//  CurrencyRateVC.swift
//  CurrencyConverter
//
//  Created by Robert P on 11.01.2021.
//

import UIKit

class CurrencyRateVC: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    var currencyArray = [Currency]()
    let defaults = UserDefaults.standard
    var apiService = RatesApiManager()
    
    var ecbRateDiff: Double = 0.0 {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    let formatter: NumberFormatter = {
        let nf = NumberFormatter()
        nf.maximumFractionDigits = 2
        nf.minimumFractionDigits = 0
        return nf
    }()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    override func viewWillAppear(_ animated: Bool) {
        ecbRateDiff = defaults.double(forKey: "ecbDiff")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ecbRateDiff = defaults.double(forKey: "ecbDiff")
        
        apiService.delegate = self
        
        apiService.getRates(url: K.ratesUrl) { (rates) in
            
            var fetchedArray = [Currency]()
            
            for (a,i) in rates.rates {
                let newCurrency = Currency(symbol: a, rate: i, name: nil)
                fetchedArray.append(newCurrency)
            }
            self.currencyArray = fetchedArray.sorted { $0.symbol < $1.symbol }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - TableView Delegates
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencyArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "rateCell", for: indexPath)
        cell.textLabel?.text = "  \(currencyArray[indexPath.row].flag)  \(currencyArray[indexPath.row].symbol)"
        cell.detailTextLabel?.text = formatter.string(from: NSNumber(value: currencyArray[indexPath.row].rate ?? 0.0 + (currencyArray[indexPath.row].rate ?? 0.0 * self.ecbRateDiff / 100)))
        cell.textLabel?.font = UIFont(name: "Avenir", size: 19)
        cell.textLabel?.textColor = UIColor(named: "fontColor")
        cell.detailTextLabel?.font = UIFont(name: "Avenir-Medium", size: 19)
        cell.detailTextLabel?.textColor = UIColor(named: "fontColor")
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
}

extension CurrencyRateVC: UISearchBarDelegate {
    
}

//MARK: - Error handling
extension CurrencyRateVC: RatesManagerDelegate {
    func didFailWithError(error: Error) {
        DispatchQueue.main.async {
            self.showAlertMessage(title: "Connection Error", message: error.localizedDescription)
        }
    }
}

