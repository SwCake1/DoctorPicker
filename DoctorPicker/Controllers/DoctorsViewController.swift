//
//  DoctorsViewController.swift
//  DoctorPicker
//
//  Created by Владислав Самохин on 07.02.2018.
//  Copyright © 2018 Владислав Самохин. All rights reserved.
//

import UIKit

class DoctorsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        NetworkService.shared.getDoctors(bySpecialityId: "100") { [weak self] doctors in
            guard let doctorArray = doctors else {
                return
            }
            for item in doctorArray {
                //                print(item.name)
            }
        }
    }

}
