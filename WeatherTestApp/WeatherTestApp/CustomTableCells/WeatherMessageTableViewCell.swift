//
//  WeatherMessageTableViewCell.swift
//  WeatherTestApp
//
//  Created by Satsishur on 02.08.2020.
//  Copyright © 2020 name. All rights reserved.
//

import UIKit

class WeatherMessageTableViewCell: UITableViewCell {

    @IBOutlet weak var messageLabel: UILabel!
    
    static let identifier = "WeatherMessageTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "WeatherMessageTableViewCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        messageLabel.adjustsFontSizeToFitWidth = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
