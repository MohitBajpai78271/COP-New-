//
//  ActiveUser.swift
//  COP
//
//  Created by Mac on 24/07/24.
//

import Foundation

struct ActiveUser: Codable {
    let id: String
    let name: String
    let mobileNumber: String
    let areas: [String]
    let dutyStartTime: String
    let dutyEndTime: String
//    let token : String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case mobileNumber
        case areas
        case dutyStartTime
        case dutyEndTime
//        case token
    }
}
