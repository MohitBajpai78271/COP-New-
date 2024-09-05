//
//  OTPViewController.swift
//  ConstableOnPatrol
//
//  Created by Mac on 10/07/24.
//

import UIKit

class OTPViewController: UIViewController{
     
    @IBOutlet weak var otpText1: UITextField!
    @IBOutlet weak var otpText2: UITextField!
    @IBOutlet weak var otpText3: UITextField!
    @IBOutlet weak var otpText4: UITextField!
    @IBOutlet weak var otpText5: UITextField!
    @IBOutlet weak var otpText6: UITextField!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var resendButton: UIButton!
    
    var phoneNumber : String?
    
    var timer : Timer?
    var remainingSeconds = 120
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        otpText1.delegate = self
        otpText2.delegate = self
        otpText3.delegate = self
        otpText4.delegate = self
        otpText5.delegate = self
        otpText6.delegate = self
        
        otpTextFieldSetUp()
    
        startTimer()
        
        resendButton.isHidden = true
    }
    
 
    @IBAction func verifyPressed(_ sender: UIButton) {
        guard let otp1 = otpText1.text,
              let otp2 = otpText2.text,
              let otp3 = otpText3.text,
              let otp4 = otpText4.text,
              let otp5 = otpText5.text,
              let otp6 = otpText6.text,
              !otp1.isEmpty, !otp2.isEmpty, !otp3.isEmpty, !otp4.isEmpty, !otp5.isEmpty, !otp6.isEmpty,
              let phoneNumber = phoneNumber else {
            showSnackBar(message: "Please enter the full OTP")
            return
        }
        
        let otp = otp1 + otp2 + otp3 + otp4 + otp5 + otp6
        
        AuthService.shared.existingUser(phoneNumber: phoneNumber, otp: otp) { response, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.showSnackBar(message: "Failed to verify OTP: \(error.localizedDescription)")
                    return
                }
                
                if let response = response {
                    self.showSnackBar(message: response.msg)
                    if response.success {
                        // Navigate based on user role if needed
                        // Perform your navigation here
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
    
    func otpTextFieldSetUp(){
        
        otpText1.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        otpText2.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        otpText3.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        otpText4.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        otpText5.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        otpText6.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
    }
    @IBAction func resendButtonTapped(_ sender: UIButton) {
        startTimer()
    }
    
    @objc func textFieldDidChange(_ textField: UITextField){
        let text = textField.text
        if text?.count == 1{
            
            switch textField{
            case otpText1:
                otpText2.becomeFirstResponder()
            case otpText2:
                otpText3.becomeFirstResponder()
            case otpText3:
                otpText4.becomeFirstResponder()
            case otpText4:
                otpText5.becomeFirstResponder()
            case otpText5:
                otpText6.becomeFirstResponder()
            case otpText6:
                otpText6.resignFirstResponder()
            default:
                break
            }
        }else if text?.count == 0{
            
            switch textField{
            case otpText2:
                otpText1.becomeFirstResponder()
            case otpText3:
                otpText2.becomeFirstResponder()
            case otpText4:
                otpText3.becomeFirstResponder()
            case otpText5:
                otpText4.becomeFirstResponder()
            case otpText6:
                otpText5.becomeFirstResponder()
            default:
                break
            }
        }
    }
    func startTimer(){
        remainingSeconds = 120
        timerLabel.text = "Resend in \(remainingSeconds) seconds"
        resendButton.isHidden = true
        timerLabel.isHidden = false
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    @objc func updateTimer(){
        remainingSeconds -= 1
        timerLabel.text = "Resend in \(remainingSeconds) seconds"
        
        if remainingSeconds <= 0{
            timer?.invalidate()
            timer = nil
            timerLabel.isHidden = true
            resendButton.isHidden = false
        }
    }
    
}
extension OTPViewController:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
