//
//  DataStorage.swift
//  WeatherTestApp
//
//  Created by Satsishur on 03.08.2020.
//  Copyright © 2020 name. All rights reserved.
//

import Foundation

struct DataStorage {
    static var weatherAllData: Result? {
        get {
            if UserDefaults.standard.object(forKey: "result") != nil {
                if let data = UserDefaults.standard.value(forKey: "result") as? Data {
                    let object = try? PropertyListDecoder().decode(Result.self, from: data)
                    return object
                }
            }
            return nil
        }
        set {
            UserDefaults.standard.set(try? PropertyListEncoder().encode(newValue), forKey: "result")
        }
    }
    
    static var weatherCurrentData: CurrentWeatherData? {
        get {
            if UserDefaults.standard.object(forKey: "currentResult") != nil {
                if let data = UserDefaults.standard.value(forKey: "currentResult") as? Data {
                    let object = try? PropertyListDecoder().decode(CurrentWeatherData.self, from: data)
                    return object
                }
            }
            return nil
        }
        set {
            UserDefaults.standard.set(try? PropertyListEncoder().encode(newValue), forKey: "currentResult")
        }
    }
}
