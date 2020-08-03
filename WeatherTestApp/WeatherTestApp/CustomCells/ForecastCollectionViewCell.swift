//
//  ForecastCollectionViewCell.swift
//  WeatherTestApp
//
//  Created by Satsishur on 02.08.2020.
//  Copyright © 2020 name. All rights reserved.
//

import UIKit

class ForecastCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "collectionCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "ForecastCollectionViewCell", bundle: nil)
    }

    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tempLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
