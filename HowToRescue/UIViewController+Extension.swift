//
//  UIViewController+Extension.swift
//  HowToRescue
//
//  Created by TakahashiTsubasa on 2021/03/18.
//

import UIKit

extension UIViewController {
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let actionOK = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(actionOK)
        present(alert, animated: true)
    }
    
}
