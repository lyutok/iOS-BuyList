//
//  BaseViewController.swift
//  Flash Chat iOS13
//
//  Created by Lyudmila Tokar on 4/4/21.
//  Copyright © 2021 Angela Yu. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    func showAlert(title: String, message: String)
    {
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        let alertOkAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alertOkAction)
        
        present(alertController, animated: true)
    }
}
