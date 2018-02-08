//
//  Doctor.swift
//  DoctorPicker
//
//  Created by Владислав Самохин on 07.02.2018.
//  Copyright © 2018 Владислав Самохин. All rights reserved.
//

import Foundation

struct Doctor: Codable {
    
    var id: Int?
    var name: String?
    var photoUrl: String?
    var description: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case name = "Name"
        case photoUrl = "Img"
        case description = "Description"
    }
}

// Uses for convinient parsing only
struct DoctorList: Codable  {
    var list: [Doctor]?
    
    enum CodingKeys: String, CodingKey {
        case list = "DoctorList"
    }
}
