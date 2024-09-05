//
//  SignInViwController.swift
//  ConstableOnPatrol
//
//  Created by Mac on 10/07/24.
//

import UIKit

class SignInViwController: UIViewController{
    
    @IBOutlet weak var MoblineNoTextField: UITextField!
    @IBOutlet weak var GenerateOTPView: UIButton!
    private var isAlertPresented = false
    let alertHelper = AlertManager.shared
    
    var numberIsCorrect : Bool = false
    
    let authService = AuthService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextField()
        
        GenerateOTPView.tintColor = UIColor.lightGray
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    
    func setupTextField(){
        MoblineNoTextField.delegate = self
        MoblineNoTextField.autocorrectionType = .no
        MoblineNoTextField.keyboardType = .emailAddress
    }
     
    @IBAction func GenerateOTPPressed(_ sender: UIButton) {
        
        guard let phoneNumber = MoblineNoTextField.text, !phoneNumber.isEmpty else {
            alertHelper.showAlert(on: self, message: "Phone number cannot be empty")
            return
        }
        
        let fullphoneNumber : String = "+91\(MoblineNoTextField.text!)"
        
        UserDefaults.standard.set(phoneNumber,forKey: "userPhoneNumber")
        UserDefaults.standard.synchronize()
        
        UserData.shared.isSignup = false
        
        AuthService.shared.getOTP(phoneNumber: fullphoneNumber) { response, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.alertHelper.showAlert(on: self, message: "Failed to generate OTP: \(error.localizedDescription)")
                    return
                }
                
                if let response = response {
                    UserData.shared.isSignup = false
                    self.alertHelper.showAlert(on: self, message: response.msg)
                    if response .success {
                        self.performSegue(withIdentifier: K.signinSegue, sender: fullphoneNumber)

                    }  else {
                        self.alertHelper.showAlert(on: self, message:  "No response received or data couldn't be decoded")
                    }
                }
            }
            
        }
    }
    
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }

}


extension SignInViwController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)
        
        if updatedText.count == 10 && updatedText.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil {
            GenerateOTPView.tintColor = UIColor.blue
            numberIsCorrect = true
        } else {
            GenerateOTPView.tintColor = UIColor.gray
        }
        
        return true
    }
}
