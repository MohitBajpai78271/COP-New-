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
    var phoneNumber: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backButtonTitle = "Back"
        setupLogout()
    }
    
    func setupLogout(){
        logOutOutlet.layer.borderColor = UIColor.black.cgColor
        logOutOutlet.layer.borderWidth = 2.0
        logOutOutlet.tintColor = .systemBackground
        logOutOutlet.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    @IBAction func logoutPressed(_ sender: UIButton) {
        phoneNumber = UserDefaults.standard.string(forKey: "userPhoneNumber") ?? UserDefaults.standard.string(forKey: "phoneNumberSignUp")
        
        authService.logOut(phoneNumber: phoneNumber!, context: self)

    }
}
