//
//  SettingsVC.swift
//  CurrencyConverter
//
//  Created by Robert Pinl on 21.03.2021.
//

import UIKit

class SettingsVC: UIViewController, UITextFieldDelegate {
    
    let defaults = UserDefaults.standard
    var ecbRateDiff = 0.0
    let formatter: NumberFormatter = {
        let nf = NumberFormatter()
        nf.maximumFractionDigits = 2
        nf.minimumFractionDigits = 0
        return nf
    }()
                
    @IBOutlet weak var ecbDiffTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ecbRateDiff = defaults.double(forKey: "ecbDiff")
        ecbDiffTextField.text = formatter.string(from: NSNumber(value: ecbRateDiff))

    }
    @IBAction func ecbDiffChanged(_ sender: UITextField) {
        let value = sender.text!.replacingOccurrences(of: ",", with: ".")
        guard let doubleValue = Double(value) else { return }
        ecbRateDiff = doubleValue
        defaults.set(value, forKey: "ecbDiff")
        
        if sender.text == "" {
            ecbRateDiff = 0.0
            defaults.set(0.0, forKey: "ecbDiff")
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
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
        
        return numberOfCharacters <= 5 && newText.isValidDouble(maxDecimalPlaces: 2)
    }
    
    @IBAction func backgroundPressed(_ sender: UITapGestureRecognizer) {
        ecbDiffTextField.resignFirstResponder()
    }
}
