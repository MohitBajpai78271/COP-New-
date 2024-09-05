import UIKit

class UserDetailsViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate,UIPickerViewDataSource{
    
    let topImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "Image")
        return imageView
    }()
    let userNameTextField: UITextField = {
        let textField = FloatingLabelTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Username"
        textField.borderStyle = .roundedRect
        textField.setLeftIcon(UIImage(systemName: "person.fill")!)
        textField.autocorrectionType = .no
        return textField
    }()
    
    let dobTextField: UITextField = {
        let textField = FloatingLabelTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Date of Birth"
        textField.borderStyle = .roundedRect
        textField.setLeftIcon(UIImage(systemName: "calendar")!)
        textField.autocorrectionType = .no
        return textField
    }()
    
    let genderTextField: UITextField = {
        let textField = FloatingLabelTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Gender"
        textField.borderStyle = .roundedRect
        textField.setLeftIcon(UIImage(systemName: "person.2.fill")!)
        textField.autocorrectionType = .no
        return textField
    }()
    
    let policeStationTextField: UITextField = {
        let textField = FloatingLabelTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Police Station"
        textField.borderStyle = .roundedRect
        textField.setLeftIcon(UIImage(systemName: "building.columns")!)
        textField.autocorrectionType = .no
        return textField
    }()
    let nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Next", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .blue
        button.layer.cornerRadius = 30 // Circular border with half of the height
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        return button
    }()
    let genderPicker = UIPickerView()
    let policeStationPicker = UIPickerView()
    let datePicker = UIDatePicker()
    
    let genders = CrimesAndPoliceStations.gender
    let policeStations = CrimesAndPoliceStations.policeStationPlace
    let authService = AuthService()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupGestureRecognizer()
        setupPickers()
        setupDatePicker()
    }
    
    func setupViews() {
        view.addSubview(topImageView)
        view.addSubview(userNameTextField)
        view.addSubview(dobTextField)
        view.addSubview(genderTextField)
        view.addSubview(policeStationTextField)
        view.addSubview(nextButton)
        
        nextButton.addTarget(self, action: #selector(nextButtonPressed), for: .touchUpInside)
        
        userNameTextField.delegate = self
        dobTextField.delegate = self
        genderTextField.delegate = self
        policeStationTextField.delegate = self
        
        
        userNameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        dobTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        genderTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        policeStationTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        
        NSLayoutConstraint.activate([
            topImageView.widthAnchor.constraint(equalToConstant: 150),
            topImageView.heightAnchor.constraint(equalToConstant: 150),
            topImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            topImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            userNameTextField.topAnchor.constraint(equalTo: topImageView.bottomAnchor, constant: 20),
            userNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            userNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            userNameTextField.heightAnchor.constraint(equalToConstant: 60),
            
            dobTextField.topAnchor.constraint(equalTo: userNameTextField.bottomAnchor, constant: 20),
            dobTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            dobTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            dobTextField.heightAnchor.constraint(equalToConstant: 60),
            
            genderTextField.topAnchor.constraint(equalTo: dobTextField.bottomAnchor, constant: 20),
            genderTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            genderTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            genderTextField.heightAnchor.constraint(equalToConstant: 60),
            
            policeStationTextField.topAnchor.constraint(equalTo: genderTextField.bottomAnchor, constant: 20),
            policeStationTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            policeStationTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            policeStationTextField.heightAnchor.constraint(equalToConstant: 60),
            
            nextButton.topAnchor.constraint(equalTo: policeStationTextField.bottomAnchor, constant: 20),
            nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            nextButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc func nextButtonPressed() {
        if validateTextFields(){
            showAlertView()
        }
    }
    
    func validateTextFields() -> Bool {
        /*return !userNameTextField.text?.isEmpty && !dobTextField.text.isEmpty && !genderTextField.text.isEmpty && !policeStationTextField.text.isEmpty*/
        return true
    }
    
    func showAlertView() {
        
        view.subviews.forEach { subview in
            if subview.tag == 99 {
                subview.removeFromSuperview()
            }
        }
        let alertView = UIView()
        alertView.translatesAutoresizingMaskIntoConstraints = false
        alertView.backgroundColor = .white
        alertView.layer.cornerRadius = 12
        alertView.layer.shadowColor = UIColor.black.cgColor
        alertView.layer.shadowOpacity = 0.2
        alertView.layer.shadowOffset = CGSize(width: 0, height: 2)
        alertView.layer.shadowRadius = 4
        
        let alertImageView = UIImageView()
        alertImageView.translatesAutoresizingMaskIntoConstraints = false
        alertImageView.contentMode = .scaleAspectFit
        alertImageView.image = UIImage(named: "Image") // Replace with your image name
        
        let alertLabel = UILabel()
        alertLabel.translatesAutoresizingMaskIntoConstraints = false
        alertLabel.text = "Welcome to Constable On Patrol"
        alertLabel.textColor = UIColor.systemBackground
        alertLabel.font = UIFont.boldSystemFont(ofSize: 18)
        alertLabel.numberOfLines = 0
        alertLabel.textAlignment = .center
        
        let alertTextView = UITextView()
        alertTextView.translatesAutoresizingMaskIntoConstraints = false
        alertTextView.isEditable = false
        alertTextView.font = UIFont.systemFont(ofSize: 16)
        alertTextView.text = """
         1. Open the App:  Ensure the application is installed on your device and is on during the time of patrolling.
         
         2. Enable Location Services:  Turn on the location services to ensure accurate functionality.
         
         3. Check Internet Connection:  Verify that your device is connected to a stable internet connection.
         
         4. Edit Profile:  -Go to profole section within app.
         -Select "Edit Profle".
         -Update your information as needed and save the changes.
         
         5. For Any Issues:  -If you encounter any problems,please drop a message at:
         
           phone number: +919643654899
          Email: ekanshbhushan2k22@gmail.com
         
         Thank you for joining us!
         
         """
        
        let okButton = UIButton(type: .system)
        okButton.translatesAutoresizingMaskIntoConstraints = false
        okButton.setTitle("Okay", for: .normal)
        okButton.setTitleColor(.white, for: .normal)
        okButton.backgroundColor = .blue
        okButton.layer.cornerRadius = 25 // Circular border with half of the height
        okButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        okButton.addTarget(self, action: #selector(dismissAlertView), for: .touchUpInside)
        
        alertView.addSubview(alertImageView)
        alertView.addSubview(alertLabel)
        alertView.addSubview(alertTextView)
        alertView.addSubview(okButton)
        view.addSubview(alertView)
        
        NSLayoutConstraint.activate([
            alertView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            alertView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            alertView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            alertView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.8),
            
            alertImageView.widthAnchor.constraint(equalToConstant: 100),
            alertImageView.heightAnchor.constraint(equalToConstant: 100),
            alertImageView.topAnchor.constraint(equalTo: alertView.topAnchor, constant: 20),
            alertImageView.centerXAnchor.constraint(equalTo: alertView.centerXAnchor),
            
            alertLabel.topAnchor.constraint(equalTo: alertImageView.bottomAnchor, constant: 20),
            alertLabel.leadingAnchor.constraint(equalTo: alertView.leadingAnchor, constant: 20),
            alertLabel.trailingAnchor.constraint(equalTo: alertView.trailingAnchor, constant: -20),
            
            alertTextView.topAnchor.constraint(equalTo: alertLabel.bottomAnchor, constant: 20),
            alertTextView.leadingAnchor.constraint(equalTo: alertView.leadingAnchor, constant: 20),
            alertTextView.trailingAnchor.constraint(equalTo: alertView.trailingAnchor, constant: -20),
            alertTextView.bottomAnchor.constraint(equalTo: okButton.topAnchor, constant: -20),
            
            okButton.bottomAnchor.constraint(equalTo: alertView.bottomAnchor, constant: -20),
            okButton.leadingAnchor.constraint(equalTo: alertView.leadingAnchor, constant: 20),
            okButton.trailingAnchor.constraint(equalTo: alertView.trailingAnchor, constant: -20),
            okButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    
    @objc func dismissAlertView() {
        if let alertView = view.subviews.first(where: { $0.tag == 99 }) {
            UIView.animate(withDuration: 0.3, animations: {
                alertView.alpha = 0
            }) { _ in
                alertView.removeFromSuperview()
                // Now perform the user creation and navigation
                self.performUserCreationAndNavigation()
            }
        } else {
            // If the alert view was not found, just perform the user creation and navigation
            self.performUserCreationAndNavigation()
        }
    }
    
    
    private func performUserCreationAndNavigation(){
        
        guard let userName = userNameTextField.text, !userName.isEmpty,
              let dob = dobTextField.text, !dob.isEmpty,
              let gender = genderTextField.text, !gender.isEmpty,
              let address = policeStationTextField.text, !address.isEmpty else {
            print("All fields are required")
            return
        }
        
        authService.createUser(
            context: self,
            userName: userName,
            phoneNumber: UserDefaults.standard.string(forKey: "phoneNumberSignUp") ?? "",
            dateOfBirth: dob,
            gender: gender,
            address: address
        ) {
            print("User creation completed")
            print("User Name: \(userName)")
            print("Phone Number signup: \(String(describing: UserDefaults.standard.string(forKey: "phoneNumberSignUp")))")
            print("Date of Birth: \(dob)")
            print("Gender: \(gender)")
            print("Address: \(address)")
            print("Token: \(UserDefaults.standard.string(forKey: "x-auth-token") ?? " no found token createuser")")
            print("User Role: \(UserDefaults.standard.string(forKey: "userRole") ?? "no found userRole createuser")")
            
            DispatchQueue.main.async{
                
                UserDefaults.standard.set(userName, forKey: "userName")
                UserDefaults.standard.set(dob, forKey: "dateOfBirth")
                UserDefaults.standard.set(gender, forKey: "gender")
                UserDefaults.standard.set(address, forKey: "address")
                UserDefaults.standard.set(true, forKey: "isLoggedIn")
                UserDefaults.standard.synchronize()
                
                
                self.dismiss(animated: true) {
                    if let tabBarVC = self.storyboard?.instantiateViewController(withIdentifier: "TabBarViewController") {
                        tabBarVC.modalPresentationStyle = .fullScreen
                        self.present(tabBarVC, animated: true, completion: nil)
                    } else {
                        print("TabBarViewController could not be instantiated")
                    }
                }
            }
        }
        
    }
    @objc func textFieldDidChange(_ textField: UITextField) {
        checkTextFields()
    }
    
    func checkTextFields() {
        nextButton.isEnabled = validateTextFields()
        nextButton.backgroundColor = validateTextFields() ? .systemBlue : .systemGray
    }
    
    func setupPickers() {
        genderPicker.delegate = self
        genderPicker.dataSource = self
        policeStationPicker.delegate = self
        policeStationPicker.dataSource = self
        
        genderTextField.inputView = genderPicker
        policeStationTextField.inputView = policeStationPicker
        // Set up the toolbar
        genderTextField.inputAccessoryView = createToolbar()
        policeStationTextField.inputAccessoryView = createToolbar()
    }
    
    func setupDatePicker() {
        datePicker.datePickerMode = .date
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        dobTextField.inputView = datePicker
        dobTextField.inputAccessoryView = createToolbar()
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
        if dobTextField.isFirstResponder {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            dobTextField.text = dateFormatter.string(from: datePicker.date)
        }
        view.endEditing(true)
    }
    
    func setupGestureRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    // UIPickerViewDelegate and UIPickerViewDataSource methods
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == genderPicker {
            return genders.count
        } else if pickerView == policeStationPicker {
            return policeStations.count
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == genderPicker {
            return genders[row]
        } else if pickerView == policeStationPicker {
            return policeStations[row]
        }
        return nil
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == genderPicker {
            genderTextField.text = genders[row]
        } else if pickerView == policeStationPicker {
            policeStationTextField.text = policeStations[row]
        }
    }
}

extension UITextField {
    func setLeftIcon(_ icon: UIImage) {
        let iconView = UIImageView(frame: CGRect(x: 10, y: 5, width: 24, height: 24))
        iconView.image = icon
        iconView.tintColor = .gray
        
        let iconContainerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 34))
        iconContainerView.addSubview(iconView)
        leftView = iconContainerView
        leftViewMode = .always
    }
}
