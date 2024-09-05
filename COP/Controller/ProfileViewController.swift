//
//  ProfileViewController.swift
//  ConstableOnPatrol
//
//  Created by Mac on 12/07/24.
//

import UIKit

class ProfileViewController: UIViewController, UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource{
    
    @IBOutlet weak var NameOfPerson: UITextField!
    @IBOutlet weak var DateOfBirth: UITextField!
    @IBOutlet weak var MobileNo: UITextField!
    @IBOutlet weak var PoliceStation: UITextField!
    @IBOutlet weak var editView: UIButton!
    
    var buttonImageNames: [UIButton: String] = [:]
    let image1 = "square.and.pencil"
    let image2 = "square.and.arrow.down.fill"
    
    func setupButton() {
        let initialImage = UIImage(systemName: image1)
        editView.setImage(initialImage, for: .normal)
        buttonImageNames[editView] = image1
        print("Button setup with image: \(image1)")
        enableTextFields(false)
    }
    
    
    let options = CrimesAndPoliceStations.policeStationPlace
    var pickerView : UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NameOfPerson.delegate = self
        DateOfBirth.delegate = self
        MobileNo.delegate = self
        PoliceStation.delegate = self
        
        pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        
        PoliceStation.inputView = pickerView
        
        setupButton()
        
        if let number = UserData.shared.phoneNumber {
                   MobileNo.text = number
               }
        
        let toolbar = UIToolbar()
               toolbar.sizeToFit()
               let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePressed))
               toolbar.setItems([doneButton], animated: true)
               PoliceStation.inputAccessoryView = toolbar
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
    }
    
    @IBAction func dropDownPressed(_ sender: UIButton) {
        PoliceStation.becomeFirstResponder()
    }
    
    @IBAction func editPressed(_ sender: UIButton) {
        print("Button pressed: \(sender)")
             print("Current button image names: \(buttonImageNames)")

             // Retrieve the current image name
             guard let currentImageName = buttonImageNames[sender] else {
                 print("No image name found.")
                 return
             }

             print("Current image name: \(currentImageName)") // Debugging

             // Toggle image based on current image
             
             if currentImageName == image1 {
                 toggleButtonImage(to: image2, for: sender)
                 enableTextFields(true)
                 
             } else {
                 showAlertToSaveChanges()
                 toggleButtonImage(to: image1, for: sender)
             }

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

      // UIPickerView DataSource and Delegate Methods
      func numberOfComponents(in pickerView: UIPickerView) -> Int {
          return 1
      }

      func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
          return options.count
      }

      func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
          return options[row]
      }

      func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
          PoliceStation.text = options[row]
      }
    
    func toggleButtonImage(to newImageName: String, for button: UIButton) {
          let newImage = UIImage(systemName: newImageName)
          button.setImage(newImage, for: .normal)
          buttonImageNames[button] = newImageName
          print("Updated image name: \(newImageName)") // Debugging
      }

      func enableTextFields(_ enable: Bool) {
          NameOfPerson.isUserInteractionEnabled = enable
          DateOfBirth.isUserInteractionEnabled = enable
          MobileNo.isUserInteractionEnabled = enable
          PoliceStation.isUserInteractionEnabled = enable
      }

      func showAlertToSaveChanges() {
          let alert = UIAlertController(title: "Save Changes?", message: "Are you sure you want to save all changes?", preferredStyle: .alert)

          let okAction = UIAlertAction(title: "OK", style: .default) { _ in
              self.enableTextFields(false)
              self.saveUserData()
          }

          let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
              // Revert back to the edit mode if canceled
              self.toggleButtonImage(to: self.image1, for: self.editView)
              self.enableTextFields(true)
          }

          alert.addAction(okAction)
          alert.addAction(cancelAction)

          present(alert, animated: true, completion: nil)
      }
    func saveUserData() {
           guard let userName = NameOfPerson.text, !userName.isEmpty,
                 let phoneNumber = MobileNo.text, !phoneNumber.isEmpty,
                 let dateOfBirth = DateOfBirth.text, !dateOfBirth.isEmpty,
                 let gender = PoliceStation.text, !gender.isEmpty else {
               showSnackBar(context: self, message: "All fields are required")
               return
           }

           if buttonImageNames[editView] == image1 {
               // Create a new user if the button is in the 'edit' mode
               AuthService.shared.createUser(context: self, userName: userName, phoneNumber: phoneNumber, dateOfBirth: dateOfBirth, gender: gender, address: "")
           } else {
               // Update existing user if the button is in the 'save' mode
               AuthService.shared.updateUser(context: self, phoneNumber: phoneNumber, userName: userName, address: gender, dateOfBirth: dateOfBirth)
           }
       }

       func showSnackBar(context: UIViewController, message: String) {
           let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
           context.present(alert, animated: true)

           DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
               alert.dismiss(animated: true, completion: nil)
           }
       }
}
