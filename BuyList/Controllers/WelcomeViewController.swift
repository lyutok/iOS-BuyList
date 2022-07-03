//
//  ViewController.swift
//  BuyList
//
//  Created by Lyudmila Tokar on 4/11/21.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    @IBOutlet weak var appLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appLabel.text = K.appTitle
    }
    
    @IBAction func registerPressed(_ sender: UIButton) {
    }
    
    @IBAction func logInPressed(_ sender: UIButton) {
    }
    
}

