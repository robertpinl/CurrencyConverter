//
//  CurrencySelectionTableVC.swift
//  CurrencyConverter
//
//  Created by Robert Pinl on 24.02.2021.
//

import UIKit

protocol CurrencySelectionDelegate {
    func didSelectCurrency(currency: Currency)
}

class CurrencySelectionTableVC: UITableViewController {
    
    var apiService = RatesApiManager()
    var currencyArray = [Currency]()
    var filteredData = [Currency]()
    
    var delegate: CurrencySelectionDelegate?
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        apiService.delegate = self
        self.filteredData = self.currencyArray
        self.tableView.reloadData()
    }
    
    // MARK: - TableView Delegate and Data Source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "selectionCell", for: indexPath) as! CurrencySelectionTableViewCell
        let currency = filteredData[indexPath.row]
        cell.flagLabel.text = currency.flag
        cell.descriptionLabel.text = currency.name
        cell.codeLabel.text = currency.symbol
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelectCurrency(currency: filteredData[indexPath.row])
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

//MARK: - Search bar
extension CurrencySelectionTableVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredData = searchText.isEmpty ? currencyArray : currencyArray.filter { (item: Currency) -> Bool in
            return  (item.name?.range(of: searchText,options: .caseInsensitive, range: nil, locale: nil) != nil) || (item.symbol.range(of: searchText,options: .caseInsensitive, range: nil, locale: nil) != nil)
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
extension CurrencySelectionTableVC: RatesManagerDelegate {
    func didFailWithError(error: Error) {
        DispatchQueue.main.async {
            self.showAlertMessage(title: "Connection Error", message: error.localizedDescription)
            print(error)
        }
    }
}

