//
//  ViewController.swift
//  CurrencyConverter
//
//  Created by Robert P on 09.01.2021.
//

import UIKit

class CurrencyConverterVC: UIViewController, CurrencySelectionDelegate, UITextFieldDelegate, rateDifferenceProtocol {
    
    var currencyArray = [Currency]()
    let apiService = RatesApiManager()
    
    var firstCurrency: Currency?
    var secondCurrency: Currency?
    
    var selectedCurrency: Currency?
    var firstOrSecond: Bool?
    
    let defaults = UserDefaults.standard
    
    var ecbDiff: Double = 0.0
    
    let formatter: NumberFormatter = {
        let nf = NumberFormatter()
        nf.maximumFractionDigits = 2
        nf.minimumFractionDigits = 0
        return nf
    }()
    
    @IBOutlet weak var firstCurrencyButton: UIButton!
    @IBOutlet weak var firstCurrencyTextField: UITextField!
    @IBOutlet weak var secondCurrencyButton: UIButton!
    @IBOutlet weak var secondCurrencyLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        apiService.getCurrency { (rates) in
            
            var fetchedArray = [Currency]()
            
            for (a,i) in rates.rates {
                let newCurrency = Currency(name: a, rate: i)
                fetchedArray.append(newCurrency)
            }
            fetchedArray.append(Currency(name: "EUR", rate: 1.0))
            self.currencyArray = fetchedArray.sorted { $0.name < $1.name }
            
            DispatchQueue.main.async { [self] in
                
                var indexOne: Int = 8
                var indexTwo: Int = 31
                
                let defaultOne = defaults.string(forKey: "CurrencyOne")
                let defaultTwo = defaults.string(forKey: "CurrencyTwo")
                
                
                if defaultOne != nil {
                    
                    var currentIndexOne = 0
                    
                    for i in currencyArray
                    {
                        if i.name == defaultOne {
                            indexOne = currentIndexOne
                            break
                        }
                        currentIndexOne += 1
                    }
                }
                
                if defaultTwo != nil {
                    
                    var currentIndexTwo = 0
                    
                    for i in currencyArray
                    {
                        if i.name == defaultTwo {
                            indexTwo = currentIndexTwo
                            break
                        }
                        currentIndexTwo += 1
                    }
                }
                
                if currencyArray.isEmpty == false {
                    
                    firstCurrencyButton.setTitle("\(currencyArray[indexOne].flag)  \(currencyArray[indexOne].name)", for: .normal)
                    firstCurrency = currencyArray[indexOne]
                    
                    secondCurrencyButton.setTitle("\(currencyArray[indexTwo].flag)  \(currencyArray[indexTwo].name)", for: .normal)
                    secondCurrency = currencyArray[indexTwo]
                }
            }
        }
        
        ecbDiff = defaults.double(forKey: "ecbDiff")
        
        let viewController = self.tabBarController?.viewControllers?[2] as? SettingsViewController
        viewController?.delegate = self
    }
    
    //MARK: - Currency Selection
    @IBAction func firstCurrencyPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "GoToCurrencySelection", sender: self)
        firstOrSecond = true
    }
    
    @IBAction func secondCurrencyPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "GoToCurrencySelection", sender: self)
        firstOrSecond = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoToCurrencySelection" {
            let destination = segue.destination as? CurrencySelectionTableVC
            destination?.delegate = self
        }
    }
    
    //MARK: - Textfield Delegate
    @IBAction func textfieldEditingChanged(_ sender: UITextField) {
        
        if (firstCurrency != nil) && (secondCurrency != nil) {
            let firstCurrencyValue = firstCurrencyTextField.text!.replacingOccurrences(of: ",", with: ".")
            guard let input = Double(firstCurrencyValue) else { secondCurrencyLabel.text = ""; return }
            
            let value = input / Double((firstCurrency?.rate)!) * secondCurrency!.rate
            if value > 0 {
                secondCurrencyLabel.text = formatter.string(from: NSNumber(value: value + (value * self.ecbDiff / 100)))
            }
        }
        
        if firstCurrencyTextField.text == "" {
            secondCurrencyLabel.text = ""
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
        secondCurrencyLabel.text = ""
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if string.isEmpty { return true }
        
        guard let oldText = textField.text, let r = Range(range, in: oldText) else {
            return true
        }
        
        let newText = oldText.replacingCharacters(in: r, with: string)
        
        let substringToReplace = oldText[r]
        let numberOfCharacters = oldText.count - substringToReplace.count + string.count
        
        return numberOfCharacters <= 10 && newText.isValidDouble(maxDecimalPlaces: 2)
    }
    
    //Hide keyboard when user press background
    @IBAction func backgroundPressed(_ sender: UITapGestureRecognizer) {
        firstCurrencyTextField.resignFirstResponder()
    }
    
    //MARK: - Currency Selection Protocol
    func didSelectCurrency(currency: Currency) {
        
        firstCurrencyTextField.text = ""
        secondCurrencyLabel.text = ""
        if firstOrSecond! {
            firstCurrency = currency
            firstCurrencyButton.setTitle("\(currency.flag)  \(currency.name)", for: .normal)
            defaults.set(currency.name, forKey: "CurrencyOne")
            
        } else {
            secondCurrency = currency
            secondCurrencyButton.setTitle("\(currency.flag)  \(currency.name)", for: .normal)
            defaults.set(currency.name, forKey: "CurrencyTwo")
            
        }
    }
    
    func didChangeEcbDiff(percent: Double) {
        self.ecbDiff = percent
    }
}

