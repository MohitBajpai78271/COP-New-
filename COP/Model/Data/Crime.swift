//
//  Crime.swift
//  ConstableOnPatrol
//
//  Created by Mac on 11/07/24.
//

import UIKit

struct Crime : Decodable {
    let id: String
    let latitude: String
    let longitude: String
    let crimeType: String
    let date: String
    let month: String?
    let year: String?
    
    let beat : String
    let v: Int?
    
    private enum CodingKeys: String, CodingKey {
          case id = "_id"
          case latitude = "lat"
          case longitude = "long"
          case crimeType = "crime"
          case date
          case month
          case year
          case beat
        case v = "__v"
        
      }

}
