//
//  CurrencyRateVC.swift
//  CurrencyConverter
//
//  Created by Robert Pinl on 11.01.2021.
//

import UIKit

class CurrencyRateVC: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    var currencyArray = [Currency]()
    var filteredData = [Currency]()
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
        
        apiService.delegate = self
        
        apiService.getRates(url: K.ratesUrl) { (rates) in
            self.apiService.getSymbols(url: K.symbolsUrl) { (symbol) in
                
                var fetchedArray = [Currency]()
                
                for (symbol, rate) in rates.rates {
                    let newCurrency = Currency(symbol: symbol, rate: rate, name: nil)
                    fetchedArray.append(newCurrency)
                }
                
                for name in symbol.symbols {
                    if let index = fetchedArray.firstIndex(where: { $0.symbol == name.key }) {
                        fetchedArray[index].name = name.value.description
                    }
                }
                
                self.currencyArray = fetchedArray.sorted { $0.symbol < $1.symbol }
                self.filteredData = self.currencyArray
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    // MARK: - TableView Delegates
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "rateCell", for: indexPath) as! CurrencyRateTableViewCell
        let currency = filteredData[indexPath.row]
        cell.flagLabel.text = currency.flag
        cell.nameLabel.text = currency.name
        cell.symbolLabel.text = currency.symbol
        cell.rateLabel.text = formatter.string(from: NSNumber(value: filteredData[indexPath.row].rate ?? 0.0 + (filteredData[indexPath.row].rate ?? 0.0 * (self.ecbRateDiff / 100))))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchBar.resignFirstResponder()
    }
}

//MARK: - SearchBar
extension CurrencyRateVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredData = searchText.isEmpty ? currencyArray : currencyArray.filter { (item: Currency) -> Bool in
            return (item.name?.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil)  || (item.symbol.range(of: searchText,options: .caseInsensitive, range: nil, locale: nil) != nil)
        }
        tableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
        filteredData = currencyArray
        tableView.reloadData()
    }
}

//MARK: - Error handling
extension CurrencyRateVC: RatesManagerDelegate {
    func didFailWithError(error: Error) {
        DispatchQueue.main.async {
            self.showAlertMessage(title: "Connection Error", message: error.localizedDescription)
        }
    }
}

