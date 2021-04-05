//
//  CurrencySelectionTableVC.swift
//  CurrencyConverter
//
//  Created by Robert P on 24.02.2021.
//

import UIKit

protocol CurrencySelectionDelegate {
    func didSelectCurrency(currency: Currency)
}

class CurrencySelectionTableVC: UITableViewController {
    
    var apiService = RatesApiManager()
    var currencyArray = [Currency]()
    
    var delegate: CurrencySelectionDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        apiService.delegate = self
        
        apiService.getSymbols(url: K.symbolsUrl) { (symbol) in
            
            var fetchedArray = [Currency]()
            
            for (a,i) in symbol.symbols {
                let newCurrency = Currency(symbol: a, rate: nil, name: i.description)
                fetchedArray.append(newCurrency)
            }
            
            self.currencyArray = fetchedArray.sorted { $0.symbol < $1.symbol }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - TableView Delegate and Data Source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencyArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "selectionCell", for: indexPath) as! CurrencySelectionTableViewCell
        let currency = currencyArray[indexPath.row]
        cell.flagLabel.text = currency.flag
        cell.descriptionLabel.text = currency.name
        cell.codeLabel.text = currency.symbol
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelectCurrency(currency: currencyArray[indexPath.row])
        dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    //Dismiss without selection
    @IBAction func backButtonPressed(_ sender: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
}

//MARK: - Error handling
extension CurrencySelectionTableVC: RatesManagerDelegate {
    func didFailWithError(error: Error) {
        DispatchQueue.main.async {
            self.showAlertMessage(title: "Connection Error", message: error.localizedDescription)
            print(error)
        }
    }
}

