//
//  SignUpViewController.swift
//  ConstableOnPatrol
//
//  Created by Mac on 10/07/24.
//

import UIKit


struct OTPResponse2: Decodable {
    let success: Bool
    let msg: String
}

class SignUpViewController: UIViewController{
    
    @IBOutlet weak var MobileNoTextFieldSignUp: UITextField!
    @IBOutlet weak var GeneratedOTPOutlet: UIButton!
    @IBOutlet weak var warningLabel: UIView!
    @IBOutlet weak var conditionLabel: UILabel!
    
    let alertHelper = AlertManager.shared
    
    var numberIsGood : Bool = false
    private var isAlertPresented = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextField()
        GeneratedOTPOutlet.tintColor = UIColor.gray
        setupCheckBox()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissMyKeyboaed))
        view.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.modalPresentationStyle = .fullScreen
        navigationItem.hidesBackButton = false
        navigationController?.isNavigationBarHidden = false
    }

    func setupTextField(){
        MobileNoTextFieldSignUp.delegate = self
        MobileNoTextFieldSignUp.autocorrectionType = .no
    }
    
    @objc func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
     }
    
     private func setupCheckBox() {
         let checkBoxSwitch = UISwitch()
         styleCheckBox(checkBoxSwitch)
         checkBoxSwitch.addTarget(self, action: #selector(switchValueChanged(_:)), for: .valueChanged)
         self.view.addSubview(checkBoxSwitch)
         setConstraintsForCheckBox(checkBox: checkBoxSwitch)
     }

     private func styleCheckBox(_ checkBoxSwitch: UISwitch) {
         checkBoxSwitch.onTintColor = .clear // Background color when ON (clear to hide)
         checkBoxSwitch.tintColor = .lightGray
         checkBoxSwitch.thumbTintColor = .white
         checkBoxSwitch.backgroundColor = .clear
         checkBoxSwitch.layer.cornerRadius = checkBoxSwitch.frame.height / 2

         checkBoxSwitch.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
     }

     // Function to set constraints for the checkbox
     private func setConstraintsForCheckBox(checkBox: UISwitch) {
         checkBox.translatesAutoresizingMaskIntoConstraints = false

         NSLayoutConstraint.activate([
            checkBox.trailingAnchor.constraint(equalTo: conditionLabel.leadingAnchor , constant: -10), // Adjust leading anchor
             checkBox.centerYAnchor.constraint(equalTo: conditionLabel.centerYAnchor) // Center vertically with agreeToTC
         ])
     }

    
    
    @objc func switchValueChanged(_ sender: UISwitch){
        UserDefaults.standard.set(sender.isOn, forKey: "TermsAgreed")
    }
    
    @objc func dismissMyKeyboaed(){
        view.endEditing(true)
    }
    
    @IBAction func GenerateOTPPressed(_ sender: UIButton) {
        
        let termsAgreed = UserDefaults.standard.bool(forKey: "TermsAgreed")
        
    
        guard let phoneNumber = MobileNoTextFieldSignUp.text, !phoneNumber.isEmpty else {
            
            return
        }
     
        if !termsAgreed {
              
              if let presentedVC = self.presentedViewController {
                  presentedVC.dismiss(animated: false, completion: {
                      self.showTermsAgreementAlert()
                  })
              } else {
                  showTermsAgreementAlert()
              }
              return
          }
        
        if numberIsGood == false{
            warningLabel.isHidden = false
            Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { _ in
                self.warningLabel.isHidden = true
            }
        }else{
           
            UserDefaults.standard.removeObject(forKey: "userPhoneNumber")
            UserDefaults.standard.set(phoneNumber,forKey: "phoneNumberSignUp")
            UserDefaults.standard.synchronize()
            
            UserData.shared.isSignup = true
            let fullphoneNumber = "+91\(phoneNumber)"
            
            AuthService.shared.getOTP(phoneNumber: fullphoneNumber) { response, error in
                DispatchQueue.main.async{
                    if let error = error {
                        self.alertHelper.showAlert(on: self, message: "Failed to generate OTP: \(error.localizedDescription)")
                        return
                    }
                    if let response = response {
                        self.performSegue(withIdentifier: K.signupSegue, sender: fullphoneNumber)
                        self.alertHelper.showAlert(on: self, message: response.msg)
                    }
                }
            }
            
        }
    }

    func showTermsAgreementAlert(){
        let alert = UIAlertController(title: "Terms Agreement Required", message: "You must agree to our terms and condition to proceed", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert,animated: true,completion: nil)
    }
}

extension SignUpViewController: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Get the updated text
        let currentText = textField.text ?? ""
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)
        
        // Check if the updated text contains exactly 10 digits
        if updatedText.count == 10 && CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: updatedText)) {
            numberIsGood = true
            GeneratedOTPOutlet.tintColor = UIColor.blue
        } else {
            GeneratedOTPOutlet.tintColor = UIColor.gray
        }
        
        return true
    }
}


