//
//  SettingsVC.swift
//  CurrencyConverter
//
//  Created by Robert Pinl on 21.03.2021.
//

import UIKit

protocol RatesSettingsDelegate {
    func didChangeEcbDiff(percent: Double)
}

class SettingsVC: UIViewController, UITextFieldDelegate {
    
    var delegate: RatesSettingsDelegate?
    let defaults = UserDefaults.standard
    let formatter: NumberFormatter = {
        let nf = NumberFormatter()
        nf.maximumFractionDigits = 2
        nf.minimumFractionDigits = 0
        return nf
    }()
                
    @IBOutlet weak var ecbDiffTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let ecbDiff = defaults.double(forKey: "ecbDiff")
        ecbDiffTextField.text = formatter.string(from: NSNumber(value: ecbDiff))
        // Do any additional setup after loading the view.

    }
    @IBAction func ecbDiffChanged(_ sender: UITextField) {
        guard let value = Double(sender.text!) else { return }
        delegate?.didChangeEcbDiff(percent: value)
        defaults.set(value, forKey: "ecbDiff")
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text == "" {
            delegate?.didChangeEcbDiff(percent: 0.0)
            defaults.set(0.0, forKey: "ecbDiff")
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if string.isEmpty { return true }
        
        guard let oldText = textField.text, let r = Range(range, in: oldText) else {
            return true
        }
        
        let newText = oldText.replacingCharacters(in: r, with: string)
        
        let substringToReplace = oldText[r]
        let numberOfCharacters = oldText.count - substringToReplace.count + string.count
        
        return numberOfCharacters <= 5 && newText.isValidDouble(maxDecimalPlaces: 2)
    }
    
    @IBAction func backgroundPressed(_ sender: UITapGestureRecognizer) {
        ecbDiffTextField.resignFirstResponder()
    }
}
