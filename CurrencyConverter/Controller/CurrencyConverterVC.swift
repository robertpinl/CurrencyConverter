//
//  ViewController.swift
//  CurrencyConverter
//
//  Created by Robert Pinl on 09.01.2021.
//

import UIKit

class CurrencyConverterVC: UIViewController, UITextFieldDelegate {
    
    var currencyArray = [Currency]()
    var apiService = RatesApiManager()
    
    var firstCurrency: Currency?
    var secondCurrency: Currency?
    
    var selectedCurrency: Currency?
    var firstOrSecond: Bool?
    
    let defaults = UserDefaults.standard
        
    var ecbRateDiff: Double = 0.0 {
        didSet {
            self.firstCurrencyTextField.text = ""
            self.secondCurrencyLabel.text = ""
        }
    }
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        ecbRateDiff = defaults.double(forKey: "ecbDiff")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ecbRateDiff = defaults.double(forKey: "ecbDiff")
        
        apiService.delegate = self
        
        apiService.getRates(url: K.ratesUrl) { (rates) in
            self.apiService.getSymbols(url: K.symbolsUrl) { (symbol) in
                
                var fetchedArray = [Currency]()
                
                for (symbol ,rate) in rates.rates {
                    let newCurrency = Currency(symbol: symbol, rate: rate, name: nil)
                    fetchedArray.append(newCurrency)
                }
                
                for name in symbol.symbols {
                    if let index = fetchedArray.firstIndex(where: { $0.symbol == name.key }) {
                        fetchedArray[index].name = name.value.description
                    }
                }
                
                self.currencyArray = fetchedArray.sorted { $0.symbol < $1.symbol }
                
                var indexOne: Int = 46
                var indexTwo: Int = 150
                
                let defaultOne = self.defaults.string(forKey: "CurrencyOne")
                let defaultTwo = self.defaults.string(forKey: "CurrencyTwo")
                
                if defaultOne != nil {
                    var currentIndexOne = 0
                    
                    for i in self.currencyArray
                    {
                        if i.symbol == defaultOne {
                            indexOne = currentIndexOne
                            break
                        }
                        currentIndexOne += 1
                    }
                }
                
                if defaultTwo != nil {
                    var currentIndexTwo = 0
                    
                    for i in self.currencyArray
                    {
                        if i.symbol == defaultTwo {
                            indexTwo = currentIndexTwo
                            break
                        }
                        currentIndexTwo += 1
                    }
                }
                
                DispatchQueue.main.async { [self] in
                    if currencyArray.isEmpty == false {
                        
                        firstCurrencyButton.setTitle("\(currencyArray[indexOne].flag)  \(currencyArray[indexOne].symbol)", for: .normal)
                        firstCurrency = currencyArray[indexOne]
                        
                        secondCurrencyButton.setTitle("\(currencyArray[indexTwo].flag)  \(currencyArray[indexTwo].symbol)", for: .normal)
                        secondCurrency = currencyArray[indexTwo]
                }
            }
        }
    }
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
            destination?.currencyArray = self.currencyArray
        }
    }
    
    //MARK: - Textfield Delegate
    @IBAction func textfieldEditingChanged(_ sender: UITextField) {
        
        if (firstCurrency != nil) && (secondCurrency != nil) {
            let firstCurrencyValue = firstCurrencyTextField.text!.replacingOccurrences(of: ",", with: ".")
            guard let input = Double(firstCurrencyValue) else { secondCurrencyLabel.text = ""; return }
            
            let value = input / Double((firstCurrency?.rate)!) * secondCurrency!.rate!
            if value > 0 {
                secondCurrencyLabel.text = formatter.string(from: NSNumber(value: value + (value * self.ecbRateDiff / 100)))
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
    
    //User input validation
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
    
}
//MARK: - Currency Selection Protocol
extension CurrencyConverterVC: CurrencySelectionDelegate {
    func didSelectCurrency(currency: Currency) {
        
        firstCurrencyTextField.text = ""
        secondCurrencyLabel.text = ""
        
        if firstOrSecond! {
            firstCurrency = currency
            firstCurrencyButton.setTitle("\(currency.flag)  \(currency.symbol)", for: .normal)
            defaults.set(currency.symbol, forKey: "CurrencyOne")
            
        } else {
            secondCurrency = currency
            secondCurrencyButton.setTitle("\(currency.flag)  \(currency.symbol)", for: .normal)
            defaults.set(currency.symbol, forKey: "CurrencyTwo")
            
        }
    }
}

//MARK: - Error handling
extension CurrencyConverterVC: RatesManagerDelegate {
    func didFailWithError(error: Error) {
        DispatchQueue.main.async {
            self.showAlertMessage(title: "Connection Error", message: error.localizedDescription)
        }
    }
}

