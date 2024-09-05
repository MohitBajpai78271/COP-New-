//
//  Location.swift
//  COP
//
//  Created by Mac on 25/07/24.
//

import Foundation

struct Location: Codable {
    let id: String
    let timestamp: String
    let v: Int
    let latitude: Double
    let longitude: Double
    let phoneNumber : String
    let userId : String
    
    
    enum CodingKeys: String, CodingKey {
           case id = "_id"
           case timestamp
           case v = "__v"
           case latitude
           case longitude
           case phoneNumber
           case userId
       }
}
