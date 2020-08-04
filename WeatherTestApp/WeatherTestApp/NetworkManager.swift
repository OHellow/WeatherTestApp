//
//  Networkmanager.swift
//  WeatherTestApp
//
//  Created by Satsishur on 31.07.2020.
//  Copyright © 2020 name. All rights reserved.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    
//    let URL_SAMPLE = "https://api.openweathermap.org/data/2.5/onecall?lat=60.99&lon=30.9&appid=1fbda9403f5071896e3ede31f94dfa52"
    let URL_API_KEY = "1fbda9403f5071896e3ede31f94dfa52"
    var URL_LATITUDE = "60.99"
    var URL_LONGITUDE = "30.9"
    var URL_GET_ONE_CALL = ""
    let URL_BASE = "https://api.openweathermap.org/data/2.5"
    var URL_CURRENT = "https://api.openweathermap.org/data/2.5/weather?lat="
    var URL_CURRENT_CALL = ""
//    let cur_sample = "https://api.openweathermap.org/data/2.5/weather?lat=60.99&lon=30.9&appid=1fbda9403f5071896e3ede31f94dfa52"
    
    let session = URLSession(configuration: .default)
    
    func buildURL() -> String {
        URL_GET_ONE_CALL = "/onecall?lat=" + URL_LATITUDE + "&lon=" + URL_LONGITUDE + "&appid=" + URL_API_KEY
        return URL_BASE + URL_GET_ONE_CALL
    }
    
    func buildCurrentURL() -> String {
        URL_CURRENT_CALL = URL_CURRENT + URL_LATITUDE + "&lon=" + URL_LONGITUDE + "&appid=" + URL_API_KEY
        return URL_CURRENT_CALL
    }
    
    func setLatitude(_ latitude: Double) {
        URL_LATITUDE = String(latitude)
    }
    
    func setLongitude(_ longitude: Double) {
        URL_LONGITUDE = String(longitude)
    }
    
    func getAllWeather(onSuccess: @escaping (Result) -> Void, onError: @escaping (String) -> Void) {
        guard let url = URL(string: buildURL()) else {
            onError("Error building URL")
            return
        }
        
        let task = session.dataTask(with: url) { (data, response, error) in
            
            DispatchQueue.main.async {
                if let error = error {
                    onError(error.localizedDescription)
                    return
                }
                
                guard let data = data, let response = response as? HTTPURLResponse else {
                    onError("Invalid data or response")
                    return
                }
                
                do {
                    if response.statusCode == 200 {
                        let items = try JSONDecoder().decode(Result.self, from: data)
                        onSuccess(items)
                    } else {
                        onError("Response wasn't 200. It was: " + "\(response.statusCode)")
                    }
                } catch {
                    onError(error.localizedDescription)
                }
            }
        }
        task.resume()
    }
    
    func getCurrentWeather(onSuccess: @escaping (CurrentWeatherData) -> Void, onError: @escaping (String) -> Void) {
        guard let url = URL(string: buildCurrentURL()) else {
            onError("Error building URL")
            return
        }
        
        let task = session.dataTask(with: url) { (data, response, error) in
            
            DispatchQueue.main.async {
                if let error = error {
                    onError(error.localizedDescription)
                    return
                }
                
                guard let data = data, let response = response as? HTTPURLResponse else {
                    onError("Invalid data or response")
                    return
                }
                
                do {
                    if response.statusCode == 200 {
                        let items = try JSONDecoder().decode(CurrentWeatherData.self, from: data)
                        onSuccess(items)
                    } else {
                        onError("Response wasn't 200. It was: " + "\(response.statusCode)")
                    }
                } catch {
                    onError(error.localizedDescription)
                }
            }
        }
        task.resume()
    }
}
