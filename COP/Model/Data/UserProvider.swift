//
//  UserProvider.swift
//  ConstableOnPatrol
//
//  Created by Mac on 18/07/24.
//

import UIKit

struct UserProvider: Codable {
       let token: String
       let _id: String
       let userName: String?
       let phoneNumber: String?
    
    init(from decoder: Decoder) throws {
          let container = try decoder.container(keyedBy: CodingKeys.self)
          token = try container.decode(String.self, forKey: .token)
          _id = try container.decode(String.self, forKey: ._id)
          userName = try container.decodeIfPresent(String.self, forKey: .userName)
          phoneNumber = try container.decodeIfPresent(String.self, forKey: .phoneNumber)
      }
    private enum CodingKeys: String, CodingKey {
            case token
            case _id
            case userName
            case phoneNumber
        }
}

