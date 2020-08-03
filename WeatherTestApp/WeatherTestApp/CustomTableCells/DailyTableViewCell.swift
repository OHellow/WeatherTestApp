//
//  DailyTableViewCell.swift
//  WeatherTestApp
//
//  Created by Satsishur on 02.08.2020.
//  Copyright © 2020 name. All rights reserved.
//

import UIKit

class DailyTableViewCell: UITableViewCell {

    @IBOutlet weak var day1: UILabel!
    @IBOutlet weak var day2: UILabel!
    @IBOutlet weak var day3: UILabel!
    @IBOutlet weak var day4: UILabel!
    @IBOutlet weak var day5: UILabel!
    @IBOutlet weak var day6: UILabel!
    @IBOutlet weak var day7: UILabel!
    
    @IBOutlet weak var icon1: UIImageView!
    @IBOutlet weak var icon2: UIImageView!
    @IBOutlet weak var icon3: UIImageView!
    @IBOutlet weak var icon4: UIImageView!
    @IBOutlet weak var icon5: UIImageView!
    @IBOutlet weak var icon6: UIImageView!
    @IBOutlet weak var icon7: UIImageView!
    
    @IBOutlet weak var tempMax1: UILabel!
    @IBOutlet weak var tempMax2: UILabel!
    @IBOutlet weak var tempMax3: UILabel!
    @IBOutlet weak var tempMax4: UILabel!
    @IBOutlet weak var tempMax5: UILabel!
    @IBOutlet weak var tempMax6: UILabel!
    @IBOutlet weak var tempMax7: UILabel!
    
    @IBOutlet weak var tempMin1: UILabel!
    @IBOutlet weak var tempMin2: UILabel!
    @IBOutlet weak var tempMin3: UILabel!
    @IBOutlet weak var tempMin4: UILabel!
    @IBOutlet weak var tempMin5: UILabel!
    @IBOutlet weak var tempMin6: UILabel!
    @IBOutlet weak var tempMin7: UILabel!
    
    static let identifier = "DailyTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "DailyTableViewCell", bundle: nil)
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tempMax1.adjustsFontSizeToFitWidth = true
        tempMax2.adjustsFontSizeToFitWidth = true
        tempMax3.adjustsFontSizeToFitWidth = true
        tempMax4.adjustsFontSizeToFitWidth = true
        tempMax5.adjustsFontSizeToFitWidth = true
        tempMax6.adjustsFontSizeToFitWidth = true
        tempMax7.adjustsFontSizeToFitWidth = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
