//
//  ViewController.swift
//  DoctorPicker
//
//  Created by Владислав Самохин on 07.02.2018.
//  Copyright © 2018 Владислав Самохин. All rights reserved.
//

import UIKit

class SpecialitiesViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    var specsInSections = [[Speciality]]()
    var firstLetters = [String]()
    
    // MARK: - Lyfecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        uiSetup()
        
        NetworkService.shared.getSpecList() { [weak self] specialities in
            guard let specialityArray = specialities else {
                return
            }
            
            self?.prepareData(specialities: specialityArray)
            self?.tableView.reloadData()
            self?.turnOnActivityIndicator(false)
        }
    }
    
    fileprivate func uiSetup() {
        turnOnActivityIndicator(true)
        tableView.sectionIndexColor = .dpPink
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
    
    // MARK: - Data prepare
    
    fileprivate func prepareData(specialities: [Speciality]) {
        
        firstLetters = sortedFirstLetters(fromSpecialities: specialities)
        
        // Split specialities by sections. 1 first letter - 1 section
        specsInSections = firstLetters.map { firstLetter in
            return specialities
                .filter { $0.name[0] == firstLetter }
                .sorted { $0.name < $1.name }
        }
    }
    
    fileprivate func sortedFirstLetters(fromSpecialities specialities: [Speciality]) -> [String]{
        
        let firstLetters = specialities.map { ($0.name[0] as String) }
        let uniqueFirstLetters = Array(Set(firstLetters))
        return uniqueFirstLetters.sorted()
    }
}

// MARK: - UITableView Protocol implementation

extension SpecialitiesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return specsInSections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return specsInSections[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SpecialityCell", for: indexPath)
        
        cell.textLabel?.text = specsInSections[indexPath.section][indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return firstLetters[section]
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return firstLetters
    }
}

// MARK: - Navigation

extension SpecialitiesViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard  segue.identifier == "ShowDoctors",
            let destinationVC =  segue.destination as? DoctorsViewController,
            let indexPath = tableView.indexPathForSelectedRow else {
                return
        }
        
        let specialityID = specsInSections[indexPath.section][indexPath.row].id
        destinationVC.specialityID = specialityID
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

