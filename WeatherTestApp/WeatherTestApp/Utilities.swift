//
//  Utilities.swift
//  WeatherTestApp
//
//  Created by Satsishur on 02.08.2020.
//  Copyright © 2020 name. All rights reserved.
//

import Foundation
import UIKit

class Utilities {
     class func getDayName(timeInterval: Int) -> String {
        let date = NSDate(timeIntervalSince1970: TimeInterval(timeInterval))
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.medium //Set time style
        dateFormatter.dateStyle = DateFormatter.Style.medium //Set date style
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat  = "EEEE"
        return dateFormatter.string(from: date as Date)
    }
    
    class func getTime(timeInterval: Int, isBottomView: Bool) -> String {
        let date = NSDate(timeIntervalSince1970: TimeInterval(timeInterval))
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.medium //Set time style
        dateFormatter.dateStyle = DateFormatter.Style.medium //Set date style
        dateFormatter.timeZone = TimeZone.current
        if isBottomView == true {
            dateFormatter.dateFormat  = "HH:mm"
        } else {
            dateFormatter.dateFormat  = "HH"
        }
        return dateFormatter.string(from: date as Date)
    }
    
    class func getWindDirection(fromDegrees degrees: Float) -> String {
        let directions =  ["N", "NNE", "NE", "ENE", "E", "ESE", "SE", "SSE", "S", "SSW", "SW", "WSW", "W", "WNW", "NW", "NNW"]
        let i = Int((degrees + 11.25) / 22.5)
        return directions[i % 16]
    }
}
