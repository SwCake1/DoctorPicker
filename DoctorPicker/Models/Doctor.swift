//
//  Doctor.swift
//  DoctorPicker
//
//  Created by Владислав Самохин on 07.02.2018.
//  Copyright © 2018 Владислав Самохин. All rights reserved.
//

import Foundation

struct Doctor: Codable {
    
    var id = 0
    var name = ""
    var price = 0
    var rating = ""
    var photoUrl = ""
//
    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case name = "Name"
        case price = "Price"
        case rating = "Rating"
        case photoUrl = "Img"
    }
}

// Uses for convinient parsing only
struct DoctorList: Codable  {
    var list: [Doctor]?
    
    enum CodingKeys: String, CodingKey {
        case list = "DoctorList"
    }
}
