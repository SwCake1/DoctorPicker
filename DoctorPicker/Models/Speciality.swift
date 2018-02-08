//
//  Speciality.swift
//  DoctorPicker
//
//  Created by Владислав Самохин on 07.02.2018.
//  Copyright © 2018 Владислав Самохин. All rights reserved.
//

import Foundation

struct Speciality: Codable {
    
    var id = ""
    var name = ""
    
    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case name = "Name"
    }
}

// Uses for convinient parsing only
struct SpecList: Codable  {
    var list: [Speciality]?
    
    enum CodingKeys: String, CodingKey {
        case list = "SpecList"
    }
}
