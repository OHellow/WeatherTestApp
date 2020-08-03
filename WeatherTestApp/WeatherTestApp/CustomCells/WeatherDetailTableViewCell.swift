//
//  WeatherDetailTableViewCell.swift
//  WeatherTestApp
//
//  Created by Satsishur on 02.08.2020.
//  Copyright © 2020 name. All rights reserved.
//

import UIKit

class WeatherDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var leftTitle: UILabel!
    @IBOutlet weak var leftValue: UILabel!
    @IBOutlet weak var rightTitle: UILabel!
    @IBOutlet weak var rightValue: UILabel!
    
    static let identifier = "WeatherDetailTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "WeatherDetailTableViewCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
