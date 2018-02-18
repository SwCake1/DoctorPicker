//
//  DoctorCell.swift
//  DoctorPicker
//
//  Created by Владислав Самохин on 09.02.2018.
//  Copyright © 2018 Владислав Самохин. All rights reserved.
//

import UIKit
import Kingfisher

class DoctorCell: UITableViewCell {

    // MARK: - Outlets
    
    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    
    // MARK: - Initialization
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        initRoundCorners()
    }
    
    fileprivate func initRoundCorners() {
        
        borderView.layer.borderWidth = 1.0
        borderView.layer.borderColor = UIColor(red: 230, green: 230, blue: 230).cgColor
        borderView.layer.cornerRadius = 4.0
        
        photoView.layer.cornerRadius = 4.0
        photoView.clipsToBounds = true
        
        recordButton.layer.cornerRadius = 4.0
    }
    

    // MARK: - Setup
    
    func setup(name: String, price: Int, rating: String, imageURL: String) {
        
        nameLabel.text = name
        priceLabel.text = price == 0 ? "-" : String(price)
        ratingLabel.text = rating
    
        if let url = URL(string: imageURL) {
            photoView.kf.setImage(with: url)
        }
    }
    
    // MARK: - Actions
    
    @IBAction func recordButtonTouched(_ sender: UIButton) {
        Toaster.shared.showPositiveMessage("recordButtonTouched🎉")
    }
    
}
