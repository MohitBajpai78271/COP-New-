//
//  LocationOfUser.swift
//  COP
//
//  Created by Mac on 25/07/24.
//

import Foundation

struct LocationOfUser: Codable {
    let id: String
    let userId: String
    let phoneNumber: String
    let latitude: Double
    let longitude: Double
    let timestamp: String // Correct the key to match the JSON response
    let v: Int

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case userId
        case phoneNumber
        case latitude
        case longitude
        case timestamp // Match the JSON key
        case v = "__v"
    }
}
