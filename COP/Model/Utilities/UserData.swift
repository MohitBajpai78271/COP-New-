//
//  UserData.swift
//  ConstableOnPatrol
//
//  Created by Mac on 20/07/24.
//

import Foundation

class UserData {
    static let shared = UserData()
    
    var phoneNumberSignup : String?
    var phoneNumber: String?
    var isSignup: Bool = false
    var token: String?
    var userRole: String?
    var userName : String?
    var dateOfBirth: String?
    var address : String?
    
    private init() {}
}
