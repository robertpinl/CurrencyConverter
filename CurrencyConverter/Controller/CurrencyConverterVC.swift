//
//  ViewController.swift
//  CurrencyConverter
//
//  Created by Robert P on 09.01.2021.
//

import UIKit

class CurrencyConverterVC: UIViewController, CurrencySelectionDelegate, UITextFieldDelegate {
    
    var firstCurrency: Currency?
    var secondCurrency: Currency?
    var selectedCurrency: Currency?
    var firstOrSecond: Bool?
    var hidePrice: Bool = true
    
    let apiService = RatesApiManager()
    var currencyArray = [Currency]()
    
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
                
                if currencyArray.isEmpty == false {
                    
                    firstCurrencyButton.setTitle("\(currencyArray[8].flag)  \(currencyArray[8].name)", for: .normal)
                    firstCurrency = currencyArray[8]
                    
                    secondCurrencyButton.setTitle("\(currencyArray[31].flag)  \(currencyArray[31].name)", for: .normal)
                    secondCurrency = currencyArray[31]
                }
            }
        }
    }
    
    //MARK: - Currency Selection
    @IBAction func firstCurrencyPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "GoToCurrencySelection", sender: self)
        firstOrSecond = true
        hidePrice = true
    }
    
    @IBAction func secondCurrencyPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "GoToCurrencySelection", sender: self)
        firstOrSecond = false
        hidePrice = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoToCurrencySelection" {
            let destination = segue.destination as? CurrencySelectionTableVC
            destination?.delegate = self
            destination?.currencyArray = currencyArray
            destination?.hideRate = hidePrice
        }
    }
    
    //MARK: - Textfield Delegate
    @IBAction func textfieldEditingChanged(_ sender: UITextField) {
        
        if (firstCurrency != nil) && (secondCurrency != nil) {
            guard let input = Double(firstCurrencyTextField.text!) else { secondCurrencyLabel.text = ""; return }
            
            let value = input / Double((firstCurrency?.rate)!) * secondCurrency!.rate
            if value > 0 {
                secondCurrencyLabel.text = formatter.string(from: NSNumber(value: value))
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
        
        guard let oldText = textField.text, let r = Range(range, in: oldText) else {
            return true
        }
        if string == "," {
                   textField.text = textField.text! + "."
                   return false
        }
        
        let newText = oldText.replacingCharacters(in: r, with: string)
        let isNumeric = newText.isEmpty || (Double(newText) != nil)
        let numberOfDots = newText.components(separatedBy: ".").count - 1
        
        let numberOfDecimalDigits: Int
        if let dotIndex = newText.firstIndex(of: ".") {
            numberOfDecimalDigits = newText.distance(from: dotIndex, to: newText.endIndex) - 1
        } else {
            numberOfDecimalDigits = 0
        }
        let substringToReplace = oldText[r]
        let numberOfCharacters = oldText.count - substringToReplace.count + string.count
        
        return isNumeric && numberOfDots <= 1 && numberOfDecimalDigits <= 2 && numberOfCharacters <= 10
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
        } else {
            secondCurrency = currency
            secondCurrencyButton.setTitle("\(currency.flag)  \(currency.name)", for: .normal)
        }
    }
}



