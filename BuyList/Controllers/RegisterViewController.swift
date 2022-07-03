//
//  RegisterViewController.swift
//  BuyList
//
//  Created by Lyudmila Tokar on 4/11/21.
//

import UIKit
import Firebase

class RegisterViewController: BaseViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func registerPressed(_ sender: UIButton) {
        
        if let email = emailTextField.text, let password = passwordTextField.text {
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let e = error {
                    self.showAlert(title: "Register Failed", message: e.localizedDescription)
                } else {
                    // Navigate to ListVC
                    self.performSegue(withIdentifier: K.registerSegueId, sender: self)
                    
                }
            }
        }
    }
}

