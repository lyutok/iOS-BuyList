//
//  LogInViewController.swift
//  BuyList
//
//  Created by Lyudmila Tokar on 4/11/21.
//

import UIKit
import Firebase

class LogInViewController: BaseViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func logInPressed(_ sender: Any) {
        
        if let email = emailTextField.text, let password = passwordTextField.text {
            
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let e = error {
                    self.showAlert(title: "LogIn Failed", message: e.localizedDescription)
                } else {
                    // Navigate to ListVC
                    self.performSegue(withIdentifier: K.logInSegueId, sender: self)
                }
            }
        }
    }
}
