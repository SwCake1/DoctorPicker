//
//  ViewController.swift
//  DoctorPicker
//
//  Created by Владислав Самохин on 07.02.2018.
//  Copyright © 2018 Владислав Самохин. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - Properties
    
    var specialities = [Speciality]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        NetworkService.shared.getSpecList() { [weak self] specList in
            guard let specialityArray = specList?.list! else {
                return
            }
            
            self?.specialities = specialityArray
            
            for item in self!.specialities {
                print(item.id)
            }
        }
    }
}

