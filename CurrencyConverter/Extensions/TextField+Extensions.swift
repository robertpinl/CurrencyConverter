//
//  TextField+Extensions.swift
//  CurrencyConverter
//
//  Created by Robert P on 15.05.2021.
//

import UIKit

extension UITextField {
    
    func addDoneButton() {
        let screenWidth = UIScreen.main.bounds.width
        let doneToolbar: UIToolbar = UIToolbar(frame: .init(x: 0, y: 0, width: screenWidth, height: 50))
        doneToolbar.barStyle = .default
        let flexBarButtonItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBarButtonitem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissKeyboard))
        let items = [flexBarButtonItem, doneBarButtonitem]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        inputAccessoryView = doneToolbar
    }
    
    @objc private func dismissKeyboard() {
        resignFirstResponder()
    }
}


