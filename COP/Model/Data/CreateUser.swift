//
//  CreateUser.swift
//  ConstableOnPatrol
//
//  Created by Mac on 16/07/24.
//

import UIKit

struct CreateUser : Encodable{
    let userRole: String
      let id: String
      let token: String
      let userName: String
      let phoneNumber: String
      let gender: String
      let address: String
      let dateOfBirth: String
}
