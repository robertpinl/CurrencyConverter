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
    
    let apiService = RatesApiManager()
    var currencyArray = [Currency]()
    var hideRate = Bool()
    
    
    var delegate: CurrencySelectionDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - TableView Delegates
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencyArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "selectionCell", for: indexPath)
        cell.textLabel?.text = "  \(currencyArray[indexPath.row].flag)  \(currencyArray[indexPath.row].name)"
        cell.textLabel?.tintColor = UIColor(named: "fontColor")
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelectCurrency(currency: currencyArray[indexPath.row])
        dismiss(animated: true, completion: nil)
    }
}

