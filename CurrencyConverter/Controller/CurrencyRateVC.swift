//
//  CurrencyRateVC.swift
//  CurrencyConverter
//
//  Created by Robert P on 11.01.2021.
//

import UIKit

class CurrencyRateVC: UIViewController,UITableViewDelegate, UITableViewDataSource, RatesSettingsDelegate {
    
    var currencyArray = [Currency]()
    var percentage: Double = 0.0
    var apiService = RatesApiManager()
    let formatter: NumberFormatter = {
        let nf = NumberFormatter()
        nf.maximumFractionDigits = 2
        nf.minimumFractionDigits = 0
        return nf
    }()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        apiService.delegate = self
        
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
        let viewController = self.tabBarController?.viewControllers?[2] as? SettingsVC
        viewController?.delegate = self
    }
    
    // MARK: - TableView Delegates
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencyArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "rateCell", for: indexPath)
        cell.textLabel?.text = "  \(currencyArray[indexPath.row].flag)  \(currencyArray[indexPath.row].name)"
        cell.detailTextLabel?.text = formatter.string(from: NSNumber(value: currencyArray[indexPath.row].rate + (currencyArray[indexPath.row].rate * self.percentage / 100)))
        cell.textLabel?.font = UIFont(name: "Avenir", size: 19)
        cell.textLabel?.textColor = UIColor(named: "fontColor")
        cell.detailTextLabel?.font = UIFont(name: "Avenir-Medium", size: 19)
        cell.detailTextLabel?.textColor = UIColor(named: "fontColor")
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func didChangeEcbDiff(percent: Double) {
        self.percentage = percent
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

