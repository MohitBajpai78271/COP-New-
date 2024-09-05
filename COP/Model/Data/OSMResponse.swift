//
//  OSMResponse.swift
//  ConstableOnPatrol
//
//  Created by Mac on 11/07/24.
//

import UIKit

struct OSMResponse : Decodable{
    let lat : Double
    let lon : Double
    let displayName: String
}
