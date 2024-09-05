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
    
    
    let alertHelper = AlertManager.shared

    var otpVerification : Bool = false
    
    var timer : Timer?
    var remainingSeconds = 120
    let url = "http://93.127.172.217:4000"
    var authservice = AuthService()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
        otpTextFieldSetUp()
        startTimer()
        resendButton.isHidden = true
        phoneNumber = UserDefaults.standard.string(forKey: "userPhoneNumber") ?? UserDefaults.standard.string(forKey: "phoneNumberSignUp")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func verifyPressed(_ sender: UIButton) {
        guard  let otp1 = otpText1.text,
              let otp2 = otpText2.text,
              let otp3 = otpText3.text,
              let otp4 = otpText4.text,
              let otp5 = otpText5.text,
              let otp6 = otpText6.text,
              !otp1.isEmpty, !otp2.isEmpty, !otp3.isEmpty, !otp4.isEmpty, !otp5.isEmpty, !otp6.isEmpty,
              let phoneNumber = phoneNumber else {
            self.alertHelper.showAlert(on: self, message: "Please enter the full OTP")
            return
        }
        let otp = otp1 + otp2 + otp3 + otp4 + otp5 + otp6
        let fullphoneNumber = "+91\(phoneNumber)"
        verifyOtp(phoneNumber: fullphoneNumber, otp: otp)
        print(fullphoneNumber)
    }
    
    private func verifyOtp(phoneNumber: String, otp: String) {
        
        authservice.verifyOtp(phoneNumber: phoneNumber, otp: otp, isSignUp: UserData.shared.isSignup) { result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self.otpVerification = true
                    if self.otpVerification{
                        self.handleOTPVerification()
                    }else{
                        print("otp verification failed")
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.alertHelper.showAlert(on: self, message: error.localizedDescription)
                }
            }
            
        }
    }
    
    
    func otpTextFieldSetUp(){
        
        otpText1.delegate = self
        otpText2.delegate = self
        otpText3.delegate = self
        otpText4.delegate = self
        otpText5.delegate = self
        otpText6.delegate = self
        
        
        otpText1.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        otpText2.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        otpText3.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        otpText4.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        otpText5.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        otpText6.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
    }
    @IBAction func resendButtonTapped(_ sender: UIButton) {
        let phoneNumber = UserData.shared.phoneNumber!
        let fullphoneNumber = "+91\(phoneNumber)"
        AuthService.shared.getOTP(phoneNumber: fullphoneNumber) { response, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.alertHelper.showAlert(on: self, message: "Failed to generate OTP: \(error.localizedDescription)")
                    return
                }
                
                if let response = response {
                    if response .success {
                        print("otp resend successfully")
                        
                    }  else {
                        self.alertHelper.showAlert(on: self, message:  "No response received or data couldn't be decoded")
                    }
                }
            }
        }
        
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
    private func handleOTPVerification() {
        if UserData.shared.isSignup{
            self.performSegue(withIdentifier: K.seguetoUserDetails , sender: self)
        }else{
            do{
                UserDefaults.standard.set(true, forKey: "isLoggedIn")
                UserDefaults.standard.synchronize()
                
                let isLoggedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")
                print("isLoggedIn after setting: \(isLoggedIn)")
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "segueToTab", sender: self)
                }
            }
        }
    }
}
    
    extension OTPViewController:UITextFieldDelegate{
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
        }
    }

