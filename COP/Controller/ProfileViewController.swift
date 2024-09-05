//
//  ProfileViewController.swift
//  ConstableOnPatrol
//
//  Created by Mac on 12/07/24.
//

import UIKit
import Alamofire

class ProfileViewController: UIViewController, UITextFieldDelegate{
    
    @IBOutlet weak var UserName: UITextField!
    @IBOutlet weak var DateOfBirth: UITextField!
    @IBOutlet weak var MobileNo: UITextField!
    @IBOutlet weak var PoliceStation: UITextField!
    @IBOutlet weak var editView: UIButton!
    
    var buttonImageNames: [UIButton: String] = [:]
    let image1 = "square.and.pencil"
    let image2 = "square.and.arrow.down.fill"
    let authService = AuthService()
    let doAlert = AlertManager.shared
    
    func setupButton() {
        let initialImage = UIImage(systemName: image1)
        editView.setImage(initialImage, for: .normal)
        buttonImageNames[editView] = image1
        print("Button setup with image: \(image1)")
        enableTextFields(false)
    }
    
    let datePicker = UIDatePicker()
    let options = CrimesAndPoliceStations.policeStationPlace
    var pickerView : UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInitialTexts()
        
        pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        
        PoliceStation.inputView = pickerView
        
        setupButton()
        setupDatePicker()
      
        setupToolBar()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
    }
    
    func setupToolBar(){
        
        let toolbar = UIToolbar()
               toolbar.sizeToFit()
               let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePressed))
               toolbar.setItems([doneButton], animated: true)
               PoliceStation.inputAccessoryView = toolbar
        
    }
    
    
    func setupInitialTexts(){
         
         UserName.addFloatingPlaceholder("Name Of Person")
         DateOfBirth.addFloatingPlaceholder("Date Of Birth")
         MobileNo.addFloatingPlaceholder("Mobile No")
         PoliceStation.addFloatingPlaceholder("Police Station")
         
         UserName.delegate = self
         DateOfBirth.delegate = self
         MobileNo.delegate = self
         PoliceStation.delegate = self
        
        
        if let userName = UserDefaults.standard.string(forKey: "userName") {
            UserName.text = userName
        }
        if let phoneNumber = UserDefaults.standard.string(forKey: "phoneNumber"), !phoneNumber.isEmpty {
            MobileNo.text = phoneNumber
        }
        if let dateOfBirth = UserDefaults.standard.string(forKey: "dateOfBirth") {
            DateOfBirth.text = dateOfBirth
        }
        if let address = UserDefaults.standard.string(forKey: "address") {
            PoliceStation.text = address
        }
        
    
    }

    @IBAction func dropDownPressed(_ sender: UIButton) {
        PoliceStation.becomeFirstResponder()
    }
    
    @IBAction func editPressed(_ sender: UIButton) {
             guard let currentImageName = buttonImageNames[sender] else {return}
             
             if currentImageName == image1 {
                 toggleButtonImage(to: image2, for: sender)
                 enableTextFields(true)
                 
             } else {
        
                 showAlertToSaveChanges()
                 toggleButtonImage(to: image1, for: sender)
             }
         }
    
    func setupDatePicker() {
         datePicker.datePickerMode = .date
         if #available(iOS 13.4, *) {
             datePicker.preferredDatePickerStyle = .wheels
         }
         DateOfBirth.inputView = datePicker
         DateOfBirth.inputAccessoryView = createToolbar()
     }
     
    func createToolbar() -> UIToolbar {
           let toolbar = UIToolbar()
           toolbar.sizeToFit()
           
           let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissPicker))
           let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
           
           toolbar.setItems([flexSpace, doneButton], animated: true)
           
           return toolbar
       }
    
    
    @objc func dismissPicker() {
          if DateOfBirth.isFirstResponder {
              let dateFormatter = DateFormatter()
              dateFormatter.dateFormat = "yyyy-MM-dd"
              DateOfBirth.text = dateFormatter.string(from: datePicker.date)
          }
          view.endEditing(true)
      }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
           textField.resignFirstResponder()
           return true
       }
    @objc func donePressed() {
          PoliceStation.resignFirstResponder()
      }

      func numberOfComponents(in pickerView: UIPickerView) -> Int {
          return 1
      }

 
    func toggleButtonImage(to newImageName: String, for button: UIButton) {
          let newImage = UIImage(systemName: newImageName)
          button.setImage(newImage, for: .normal)
          buttonImageNames[button] = newImageName
          print("Updated image name: \(newImageName)") // Debugging
      }

      func enableTextFields(_ enable: Bool) {
          UserName.isUserInteractionEnabled = enable
          DateOfBirth.isUserInteractionEnabled = enable
          MobileNo.isUserInteractionEnabled = enable
          PoliceStation.isUserInteractionEnabled = enable
      }

      func showAlertToSaveChanges() {
          let alert = UIAlertController(title: "Save Changes?", message: "Are you sure you want to save all changes?", preferredStyle: .alert)

          let okAction = UIAlertAction(title: "OK", style: .default) { _ in
              
              guard let phoneNumber = self.MobileNo.text, !phoneNumber.isEmpty,
                    let userName = self.UserName.text, !userName.isEmpty,
                    let address = self.PoliceStation.text, !address.isEmpty,
                    let dateOfBirth = self.DateOfBirth.text, !dateOfBirth.isEmpty else {
                  self.doAlert.showAlert(on: self, message: "Please fill in all fields")
                     return
                 }
                 
              self.authService.updateUser(context: self, phoneNumber: phoneNumber, userName: userName, address: address, dateOfBirth: dateOfBirth) { result in
                  DispatchQueue.main.async{
                  switch result {
                  case .success:
              
                      self.authService.getUserData(context: self) { result in
                                             DispatchQueue.main.async {
                                                 switch result {
                                                 case .success(let userData):
                                                     // Update and persist the values
                                                     if let phoneNumber = userData["phoneNumber"] as? String {
                                                         UserDefaults.standard.set(phoneNumber, forKey: "phoneNumber")
                                                         self.MobileNo.text = phoneNumber
                                                     }
                                                     if let userName = userData["userName"] as? String {
                                                         UserDefaults.standard.set(userName, forKey: "userName")
                                                         self.UserName.text = userName
                                                     }
                                                     if let address = userData["address"] as? String {
                                                         UserDefaults.standard.set(address, forKey: "address")
                                                         self.PoliceStation.text = address
                                                     }
                                                     if let dateOfBirth = userData["dateOfBirth"] as? String {
                                                         UserDefaults.standard.set(dateOfBirth, forKey: "dateOfBirth")
                                                         self.DateOfBirth.text = dateOfBirth
                                                     }
                                                     UserDefaults.standard.synchronize()
                                                     
                                                     self.enableTextFields(false)
                                                     self.dismiss(animated: true, completion: nil)

                                        case .failure(let error):
                                                     print("Failed to fetch updated user data: \(error.localizedDescription)")
                                                 }
                                             }
                                         }
                  case .failure(let error):
                      print("Its a failure : \(error.localizedDescription)")
                  }
              }
              }
    }
          
          let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
              self.toggleButtonImage(to: self.image1, for: self.editView)
              self.enableTextFields(true)
          }

          alert.addAction(okAction)
          alert.addAction(cancelAction)

          present(alert, animated: true, completion: nil)
      }
    
}


extension ProfileViewController: UIPickerViewDelegate,UIPickerViewDataSource{
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return options.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return options[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        PoliceStation.text = options[row]
    }
  
}

extension UITextField {
    func addFloatingPlaceholder(_ placeholder: String) {
        let placeholderLabel = UILabel()
        placeholderLabel.text = placeholder
        placeholderLabel.font = UIFont.systemFont(ofSize: 16)
        placeholderLabel.textColor = .lightGray
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(placeholderLabel)

        NSLayoutConstraint.activate([
            placeholderLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            placeholderLabel.topAnchor.constraint(equalTo: topAnchor, constant: 0)
        ])

        if traitCollection.userInterfaceStyle == .dark {
               textColor = .white
           } else {
               textColor = .black
           }
        layer.borderWidth = 1
        layer.borderColor = UIColor.lightGray.cgColor
        backgroundColor = .systemBackground
        
        self.placeholder = ""

        addTarget(self, action: #selector(editingDidBegin), for: .editingDidBegin)
        addTarget(self, action: #selector(editingDidEnd), for: .editingDidEnd)
    }

    @objc private func editingDidBegin() {
        guard let placeholderLabel = subviews.compactMap({ $0 as? UILabel }).first else { return }
          UIView.animate(withDuration: 0.3) {
              placeholderLabel.textColor = .systemBlue
              self.layer.borderColor = UIColor.systemBlue.cgColor
          }
    }

    @objc private func editingDidEnd() {
        guard let placeholderLabel = subviews.compactMap({ $0 as? UILabel }).first else { return }
          UIView.animate(withDuration: 0.3) {
              placeholderLabel.textColor = .lightGray
              self.layer.borderColor = UIColor.lightGray.cgColor
          }
          }
}

