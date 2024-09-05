//
//  SettingsViewController.swift
//  ConstableOnPatrol
//
//  Created by Mac on 12/07/24.
//

import UIKit

class SettingsViewController: UIViewController{
    
    @IBOutlet weak var logOutOutlet: UIButton!
    
    let authService = AuthService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logOutOutlet.layer.borderColor = UIColor.black.cgColor
        logOutOutlet.layer.borderWidth = 2.0
    }
    
    @IBAction func logoutPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "SegueToSignIn", sender: self)

        authService.logOut(phoneNumber: "7827139030", context: self)
    }
}
