//
//  Admin View Controller.swift
//  ConstableOnPatrol
//
//  Created by Mac on 11/07/24.
//

import UIKit

class AdminViewController: UIViewController, UITextFieldDelegate{
    
    @IBOutlet weak var searchUserNameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        BorderOfTextField()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissMyKeyboaed))
        view.addGestureRecognizer(tapGesture)
    }
    
    func BorderOfTextField(){
        searchUserNameTextField.layer.borderColor = UIColor.black.cgColor
        searchUserNameTextField.layer.borderWidth = 1.0
        searchUserNameTextField.layer.cornerRadius = 5.0
        searchUserNameTextField.delegate = self
    }
    
    @objc func dismissMyKeyboaed() {
           view.endEditing(true)
       }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
           textField.resignFirstResponder()
           return true
       }
    
    @IBAction func searchPressed(_ sender: UIButton) {
        searchUserNameTextField.endEditing(true)
    }
}
