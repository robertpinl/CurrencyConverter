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
    var rateCurrency: Currency!
    
    var ecbRateDiff: Double = 0.0 {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var titleLabel: UILabel!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
                
        ecbRateDiff = defaults.double(forKey: "ecbDiff")
        rateCurrency = currencyArray[46]
        
        var index = Int()
        defaults.string(forKey: "defaultRate")

        if (defaults.string(forKey: "defaultRate") != nil) {
            var currentIndex = 0
            for i in self.currencyArray
            {
                if i.symbol == defaults.string(forKey: "defaultRate") {
                    index = currentIndex
                    break
                }
                currentIndex += 1
            }
            rateCurrency = currencyArray[index]
            
        }
        
        titleLabel.text = "\(rateCurrency.symbol) RATE"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.currencyArray = CurrencyStore.shared.currencies
        self.filteredData = currencyArray
        
        apiService.delegate = self
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
                        
        let value = (filteredData[indexPath.row].rate! + (filteredData[indexPath.row].rate! * (self.ecbRateDiff / 100))) / rateCurrency.rate!
        
        cell.rateLabel.text = value.twoDecimalPlaceString
        
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

