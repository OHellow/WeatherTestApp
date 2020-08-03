//
//  Test3TableViewCell.swift
//  WeatherTestApp
//
//  Created by Satsishur on 02.08.2020.
//  Copyright © 2020 name. All rights reserved.
//

import UIKit

class Forecast24TableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {

    static let identifier = "Forecast24TableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "Forecast24TableViewCell", bundle: nil)
    }
    
    @IBOutlet var collectionView: UICollectionView!
    
    var forecastData: [Hourly]?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.register(ForecastCollectionViewCell.nib(), forCellWithReuseIdentifier: ForecastCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.itemSize = CGSize(width: 75, height: 120)
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        collectionView.collectionViewLayout = flowLayout
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return forecastData?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath as IndexPath) as! ForecastCollectionViewCell
        guard let forecastData = forecastData else {return cell}
        if indexPath.item == 0 {
            cell.hourLabel.text = "Now"
            cell.imageView.imageFrom(link: "https://openweathermap.org/img/wn/\(forecastData[0].weather[0].icon).png")
            cell.tempLabel.text = "\(Int(forecastData[0].temp) - 273)\u{00B0}"
        } else {
            cell.hourLabel.text = "\(Utilities.getTime(timeInterval: forecastData[indexPath.item].dt, isBottomView: false))"
            cell.imageView.imageFrom(link: "https://openweathermap.org/img/wn/\(forecastData[indexPath.item].weather[0].icon).png")
            cell.tempLabel.text = "\(Int(forecastData[indexPath.item].temp) - 273)\u{00B0}"
        }
        //cell.backgroundColor = .blue
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 75, height: 120)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
