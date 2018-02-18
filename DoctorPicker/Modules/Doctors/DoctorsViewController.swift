//
//  DoctorsViewController.swift
//  DoctorPicker
//
//  Created by Владислав Самохин on 07.02.2018.
//  Copyright © 2018 Владислав Самохин. All rights reserved.
//

import UIKit

class DoctorsViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    var doctors = [Doctor]()
    var specialityID = ""
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        turnOnActivityIndicator(true)
        
        registerCell()
        
        NetworkService.shared.getDoctors(bySpecialityId: specialityID) { [weak self] doctors in
            guard let doctorArray = doctors else {
                return
            }
            self?.doctors = doctorArray
            self?.tableView?.reloadData()
            self?.turnOnActivityIndicator(false)
        }
        
    }
    
    fileprivate func registerCell() {
        let nib = UINib(nibName: "DoctorCell", bundle: nil)
        tableView?.register(nib, forCellReuseIdentifier: "DoctorCell")
    }
    
    fileprivate func turnOnActivityIndicator(_ isActive: Bool) {
        if isActive {
            activityIndicatorView.isHidden = false
            tableView.isHidden = true
        } else {
            activityIndicatorView.isHidden = true
            tableView.isHidden = false
        }
    }
}

// MARK: - UITableView Protocol implementation

extension DoctorsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return doctors.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DoctorCell", for: indexPath)
        guard let doctorCell = cell as? DoctorCell else {
            return cell
        }
        
        let doctor = doctors[indexPath.row]
        doctorCell.setup(name: doctor.name,
                         price: doctor.price ?? 0,
                         rating: doctor.rating ?? "-",
                         imageURL: doctor.photoUrl ?? "")
        return doctorCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130.0
    }
    
}

