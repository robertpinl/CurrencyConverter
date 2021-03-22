//
//  Alert+Extension.swift
//  CurrencyConverter
//
//  Created by Robert Pinl on 22.03.2021.
//

import UIKit

extension UIViewController {
    func showAlertMessage(title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel) { (alert) in
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}
