//
//  CurrencyRateVC.swift
//  CurrencyConverter
//
//  Created by Robert P on 11.01.2021.
//

import UIKit

class CurrencyRateVC: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
        
    let apiService = RatesApiManager()
    var currencyArray = [Currency]()
    let formatter: NumberFormatter = {
        let nf = NumberFormatter()
        nf.maximumFractionDigits = 2
        nf.minimumFractionDigits = 0
        return nf
    }()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        apiService.getCurrency { (rates) in
            
            var fetchedArray = [Currency]()
            
            for (a,i) in rates.rates {
                let newCurrency = Currency(name: a, rate: i)
                fetchedArray.append(newCurrency)
            }
            self.currencyArray = fetchedArray.sorted { $0.name < $1.name }
            
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
        cell.textLabel?.text = "  \(currencyArray[indexPath.row].flag)  \(currencyArray[indexPath.row].name)"
        cell.detailTextLabel?.text = formatter.string(from: NSNumber(value: currencyArray[indexPath.row].rate))
        cell.tintColor = UIColor(named: "fontColor")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

