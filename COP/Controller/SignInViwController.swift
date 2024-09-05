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
    @IBOutlet weak var warningView: UIView!
    
    var numberIsCorrect : Bool = false
    
    let authService = AuthService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MoblineNoTextField.delegate = self
        GenerateOTPView.tintColor = UIColor.lightGray
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    
    func generateOTP() {
        
        guard let phoneNumber = MoblineNoTextField.text, !phoneNumber.isEmpty else {
            showSnackBar(message: "Phone number cannot be empty")
            return
        }
        authService.getOTP(phoneNumber: phoneNumber) { otpResponse, error in
            if let otpResponse = otpResponse {
                // Handle successful OTP generation, e.g., update UI or navigate to next screen
                print("Received OTP: \(otpResponse)")
            } else if let error = error {
                // Handle error, e.g., show alert or log the error
                print("Failed to generate OTP: \(error.localizedDescription)")
            }
        }
        
    }
    
    @IBAction func GenerateOTPPressed(_ sender: UIButton) {
        
        
        guard let phoneNumber = MoblineNoTextField.text, !phoneNumber.isEmpty else {
            showSnackBar(message: "Phone number cannot be empty")
            return
        }
        
        let fullphoneNumber : String = "+91\(MoblineNoTextField.text!)"
        print("+91\(MoblineNoTextField.text!)")
        
        AuthService.shared.getOTP(phoneNumber: fullphoneNumber) { response, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.showSnackBar(message: "Failed to generate OTP: \(error.localizedDescription)")
                    return
                }
                
                if let response = response {
                    self.showSnackBar(message: response.msg)
                    if response .success {
                        UserData.shared.phoneNumber = fullphoneNumber
                        // Navigate to the OTP verification screen
                        self.performSegue(withIdentifier: "segueToOTP", sender: phoneNumber)
                    }
                } else {
                    self.showSnackBar(message: "No response received or data couldn't be decoded")
                }
            }
        }
        
    }
    func showSnackBar(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //        if segue.identifier == "segueToOTP" {
    //            if let otpVerificationVC = segue.destination as? OTPViewController, let phoneNumber = sender as? String {
    //                otpVerificationVC.phoneNumber = phoneNumber
    //            }
    //        }
    //    }
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)
        
        // Check if the updated text contains exactly 10 digits
        if updatedText.count == 10 && updatedText.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil {
            // Change button color to active (e.g., green)
            GenerateOTPView.tintColor = UIColor.blue
            numberIsCorrect = true
        } else {
            // Reset button color to default (e.g., gray)
            GenerateOTPView.tintColor = UIColor.gray
        }
        
        return true
    }
}

extension SignInViwController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
