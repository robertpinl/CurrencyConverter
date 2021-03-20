//
//  CurrencyRateVC.swift
//  CurrencyConverter
//
//  Created by Robert P on 11.01.2021.
//

import UIKit

class CurrencyRateVC: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    
    let currency = CurrencyConverterVC()

    let apiService = RatesApiManager()
    var currencyArray = [Currency]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currencyArray = currency.currencyArray
        print(currencyArray)
    }
    
    // MARK: - TableView Delegates
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencyArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "rateCell", for: indexPath)
        cell.textLabel?.text = "\(currencyArray[indexPath.row].flag)  \(currencyArray[indexPath.row].name)"
        cell.detailTextLabel?.text = String(currencyArray[indexPath.row].rate)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

