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
        
        apiService.getCurrency { (rates) in
            
            var fetchedArray = [Currency]()
            
            for (a,i) in rates.rates {
                let newCurrency = Currency(name: a, rate: i)
                fetchedArray.append(newCurrency)
            }
            fetchedArray.append(Currency(name: "EUR", rate: 1.0))
            self.currencyArray = fetchedArray.sorted { $0.name < $1.name }
            
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "selectionCell", for: indexPath)
        cell.textLabel?.text = "  \(currencyArray[indexPath.row].flag)  \(currencyArray[indexPath.row].name)"
        cell.textLabel?.font = UIFont(name: "Avenir", size: 19)
        cell.textLabel?.textColor = UIColor(named: "fontColor")
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelectCurrency(currency: currencyArray[indexPath.row])
        dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
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
        }
    }
}

