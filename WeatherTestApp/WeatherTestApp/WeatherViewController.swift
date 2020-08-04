//
//  ViewController.swift
//  WeatherTestApp
//
//  Created by Satsishur on 31.07.2020.
//  Copyright © 2020 name. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MainViewController: UIViewController, CLLocationManagerDelegate {
    //MARK: Views
    private let topView = UIView()
    private let tableView = UITableView()
    
    private let cityLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "--"
        label.font = UIFont.systemFont(ofSize: 30, weight: .medium)
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.heightAnchor.constraint(equalToConstant: 35).isActive = true
        return label
    }()
    
    private let weatherDescLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "--"
        label.font = UIFont.systemFont(ofSize: 17)
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.heightAnchor.constraint(equalToConstant: 21).isActive = true
        return label
    }()
    
    private let tempLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "--"
        label.font = UIFont.systemFont(ofSize: 70, weight: .light)
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.heightAnchor.constraint(equalToConstant: 69).isActive = true
        return label
    }()
    
    private let minTempLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "--"
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = UIColor.systemGray
        label.textAlignment = .right
        label.adjustsFontSizeToFitWidth = true
        label.heightAnchor.constraint(equalToConstant: 24).isActive = true
        label.widthAnchor.constraint(equalToConstant: 40).isActive = true
        return label
    }()
    
    private let maxTempLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "--"
        label.font = UIFont.systemFont(ofSize: 20)
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        label.heightAnchor.constraint(equalToConstant: 24).isActive = true
        label.widthAnchor.constraint(equalToConstant: 36).isActive = true
        return label
    }()
    
    private let dayTodayLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "--- Today"
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        label.adjustsFontSizeToFitWidth = true
        label.heightAnchor.constraint(equalToConstant: 21).isActive = true
        label.widthAnchor.constraint(equalToConstant: 270).isActive = true
        return label
    }()
    //MARK: Vars
    private var locationManager = CLLocationManager()
    private var currentLocation: CLLocation?
    
    private let maxHeaderHeight: CGFloat = 250
    private let minHeaderHeight: CGFloat = 110
    private var previousScrollOffset: CGFloat = 0
    
    private var forecast24Cell: Forecast24TableViewCell!
    private var dailyForecastCell: DailyTableViewCell!
    private var weatherDetailCell: WeatherDetailTableViewCell!
    private var weatherMessageCell: WeatherMessageTableViewCell!
    //MARK:View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableView.automaticDimension
        tableView.showsVerticalScrollIndicator = false
        tableView.register(Forecast24TableViewCell.nib(), forCellReuseIdentifier: Forecast24TableViewCell.identifier)
        tableView.register(DailyTableViewCell.nib(), forCellReuseIdentifier: DailyTableViewCell.identifier)
        tableView.register(WeatherMessageTableViewCell.nib(), forCellReuseIdentifier: WeatherMessageTableViewCell.identifier)
        tableView.register(WeatherDetailTableViewCell.nib(), forCellReuseIdentifier: WeatherDetailTableViewCell.identifier)
        setupLayout()
        setupLocation()
    }
    //MARK: GetWeather Functions
    private func getAllWeather() {
        NetworkManager.shared.getAllWeather(onSuccess: { (result) in
            DataStorage.weatherAllData = result
            DataStorage.weatherAllData?.sortDailyArray()
            DataStorage.weatherAllData?.sortHourlyArray()
            self.tableView.reloadData()
        }) { (errorMessage) in
            debugPrint(errorMessage)
        }
    }
    
    private func getCurrentWeather() {
        NetworkManager.shared.getCurrentWeather(onSuccess: { (result) in
            DataStorage.weatherCurrentData = result
            DispatchQueue.main.async {
                self.setupTopViewInfo()
            }
            self.tableView.reloadData()
        }) { (error) in
            debugPrint(error)
        }
    }
    
    private func setupTopViewInfo() {
        guard let currentWeatherResult = DataStorage.weatherCurrentData else {return}
            weatherDescLabel.text = currentWeatherResult.weather[0].description
            tempLabel.text = "\(Int(currentWeatherResult.main.temp) - 273)\u{00B0}"
            dayTodayLabel.text = "\(Utilities.getDayName(timeInterval: currentWeatherResult.dt)) Today"
            minTempLabel.text = "\(Int(currentWeatherResult.main.temp_min) - 273)"
            maxTempLabel.text = "\(Int(currentWeatherResult.main.temp_max) - 273)"
    }
    //MARK: Location Setup and Manager
    func setupLocation() {
        self.cityLabel.text = UserDefaults.standard.value(forKey: "city") as? String ?? "--"
        setupTopViewInfo()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !locations.isEmpty, currentLocation == nil {
            currentLocation = locations.first
            locationManager.stopUpdatingLocation()
            guard let currentLocation = currentLocation else {
                return
            }
            let lat = currentLocation.coordinate.latitude
            let lon = currentLocation.coordinate.longitude
            NetworkManager.shared.setLatitude(lat)
            NetworkManager.shared.setLongitude(lon)
            print("lat: \(lat)")
            print("lon: \(lon)")
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(currentLocation) { (placemarks, error) in
                if let error = error {
                    debugPrint(error.localizedDescription)
                }
                if let placemarks = placemarks {
                    if placemarks.count > 0 {
                        let placemark = placemarks[0]
                        if let city = placemark.locality {
                            UserDefaults.standard.set(city, forKey: "city")
                            self.cityLabel.text = city
                        }
                    }
                }
            }
            getAllWeather()
            getCurrentWeather()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        debugPrint(error.localizedDescription)
    }
}

//MARK: TableView DataSource
extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        
        let weatherResult = DataStorage.weatherAllData
        let currentWeatherResult = DataStorage.weatherCurrentData

        if indexPath.row == 0 {
            dailyForecastCell = tableView.dequeueReusableCell(withIdentifier: DailyTableViewCell.identifier, for: indexPath) as? DailyTableViewCell
            if weatherResult != nil {
                setDataDailyForecast(dailyForecastCell: dailyForecastCell, dailyForecastModel: weatherResult!)
            }
            cell = dailyForecastCell
        } else if indexPath.row == 1 {
            weatherMessageCell = tableView.dequeueReusableCell(withIdentifier: WeatherMessageTableViewCell.identifier, for: indexPath) as? WeatherMessageTableViewCell
            if currentWeatherResult != nil {
                setDataWeatherMessageCell(weatherMessageCell: weatherMessageCell, weatherModel: currentWeatherResult!)
            }
            cell = weatherMessageCell
        } else {
            weatherDetailCell = tableView.dequeueReusableCell(withIdentifier: WeatherDetailTableViewCell.identifier, for: indexPath) as? WeatherDetailTableViewCell
            if weatherResult != nil {
                if indexPath.row == 2 {
                    setDataWeatherDetailCell(weatherDetailCell: weatherDetailCell, leftTitle: "SUNRISE", leftValue: Utilities.getTime(timeInterval: weatherResult?.current.sunrise ?? 0, isBottomView: true), rightTitle: "SUNSET", rightValue: Utilities.getTime(timeInterval: weatherResult?.current.sunset ?? 0, isBottomView: true))
                }
                else if indexPath.row == 3 {
                    setDataWeatherDetailCell(weatherDetailCell: weatherDetailCell, leftTitle: "CHANCE OF RAIN", leftValue: "22%", rightTitle: "HUMIDITY", rightValue: "\(weatherResult?.current.humidity ?? 0)%")
                }
                else if indexPath.row == 4 {
                    setDataWeatherDetailCell(weatherDetailCell: weatherDetailCell, leftTitle: "WIND", leftValue: "\(Utilities.getWindDirection(fromDegrees: Float(weatherResult?.current.wind_deg ?? 0))) \(weatherResult?.current.wind_speed ?? 0) km/hr", rightTitle: "FEELS LIKE", rightValue: "\(Int(weatherResult!.current.feels_like) - 273)\u{00B0}")
                }
                else if indexPath.row == 5 {
                    setDataWeatherDetailCell(weatherDetailCell: weatherDetailCell, leftTitle: "PRECIPITATION", leftValue: "3 mm", rightTitle: "PRESSURE", rightValue: "\(weatherResult?.current.pressure ?? 0) hPA")
                }
                else if indexPath.row == 6 {
                    setDataWeatherDetailCell(weatherDetailCell: weatherDetailCell, leftTitle: "VISIBILITY", leftValue: "\(Double(weatherResult?.current.visibility ?? 0) / 1000) km", rightTitle: "UV INDEX", rightValue: "\(weatherResult?.current.uvi ?? 0)")
                }
            }
            cell = weatherDetailCell
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        122
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell: UITableViewCell!
        guard let weatherResult = DataStorage.weatherAllData else {return forecast24Cell}
        forecast24Cell = tableView.dequeueReusableCell(withIdentifier: Forecast24TableViewCell.identifier) as? Forecast24TableViewCell
        //if weatherResult != nil {
            setDataForecast24Cell(forecast24Cell: forecast24Cell, weatherModel: weatherResult)
        //}
        cell = forecast24Cell
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
//MARK:Data Present Functions
extension MainViewController {
     func setDataDailyForecast(dailyForecastCell: DailyTableViewCell,dailyForecastModel: Result) {
        
        dailyForecastCell.day1.text = Utilities.getDayName(timeInterval: dailyForecastModel.daily[0].dt)
        dailyForecastCell.day2.text = Utilities.getDayName(timeInterval: dailyForecastModel.daily[1].dt)
        dailyForecastCell.day3.text = Utilities.getDayName(timeInterval: dailyForecastModel.daily[2].dt)
        dailyForecastCell.day4.text = Utilities.getDayName(timeInterval: dailyForecastModel.daily[3].dt)
        dailyForecastCell.day5.text = Utilities.getDayName(timeInterval: dailyForecastModel.daily[4].dt)
        dailyForecastCell.day6.text = Utilities.getDayName(timeInterval: dailyForecastModel.daily[5].dt)
        dailyForecastCell.day7.text = Utilities.getDayName(timeInterval: dailyForecastModel.daily[6].dt)
        
        dailyForecastCell.icon1.imageFrom(link: "https://openweathermap.org/img/wn/\(dailyForecastModel.daily[0].weather[0].icon).png")
        dailyForecastCell.icon2.imageFrom(link: "https://openweathermap.org/img/wn/\(dailyForecastModel.daily[1].weather[0].icon).png")
        dailyForecastCell.icon3.imageFrom(link: "https://openweathermap.org/img/wn/\(dailyForecastModel.daily[2].weather[0].icon).png")
        dailyForecastCell.icon4.imageFrom(link: "https://openweathermap.org/img/wn/\(dailyForecastModel.daily[3].weather[0].icon).png")
        dailyForecastCell.icon5.imageFrom(link: "https://openweathermap.org/img/wn/\(dailyForecastModel.daily[4].weather[0].icon).png")
        dailyForecastCell.icon6.imageFrom(link: "https://openweathermap.org/img/wn/\(dailyForecastModel.daily[5].weather[0].icon).png")
        dailyForecastCell.icon7.imageFrom(link: "https://openweathermap.org/img/wn/\(dailyForecastModel.daily[6].weather[0].icon).png")
        
        dailyForecastCell.tempMax1.text = "\(Int(dailyForecastModel.daily[0].temp.max) - 273)"
        dailyForecastCell.tempMax2.text = "\(Int(dailyForecastModel.daily[1].temp.max) - 273)"
        dailyForecastCell.tempMax3.text = "\(Int(dailyForecastModel.daily[2].temp.max) - 273)"
        dailyForecastCell.tempMax4.text = "\(Int(dailyForecastModel.daily[3].temp.max) - 273)"
        dailyForecastCell.tempMax5.text = "\(Int(dailyForecastModel.daily[4].temp.max) - 273)"
        dailyForecastCell.tempMax6.text = "\(Int(dailyForecastModel.daily[5].temp.max) - 273)"
        dailyForecastCell.tempMax7.text = "\(Int(dailyForecastModel.daily[6].temp.max) - 273)"
        
        dailyForecastCell.tempMin1.text = "\(Int(dailyForecastModel.daily[0].temp.min) - 273)"
        dailyForecastCell.tempMin2.text = "\(Int(dailyForecastModel.daily[1].temp.min) - 273)"
        dailyForecastCell.tempMin3.text = "\(Int(dailyForecastModel.daily[2].temp.min) - 273)"
        dailyForecastCell.tempMin4.text = "\(Int(dailyForecastModel.daily[3].temp.min) - 273)"
        dailyForecastCell.tempMin5.text = "\(Int(dailyForecastModel.daily[4].temp.min) - 273)"
        dailyForecastCell.tempMin6.text = "\(Int(dailyForecastModel.daily[5].temp.min) - 273)"
        dailyForecastCell.tempMin7.text = "\(Int(dailyForecastModel.daily[6].temp.min) - 273)"
    }
    
     func setDataWeatherMessageCell(weatherMessageCell: WeatherMessageTableViewCell,weatherModel: CurrentWeatherData) {
        weatherMessageCell.messageLabel.text = "Today : \(weatherModel.weather[0].description) currently. It's \(Int(weatherModel.main.temp) - 273)\u{00B0}, the high today was forecast as \(Int(weatherModel.main.temp_max) - 273)\u{00B0}"
    }
    
     func setDataWeatherDetailCell(weatherDetailCell: WeatherDetailTableViewCell, leftTitle: String, leftValue: String, rightTitle: String, rightValue: String) {
        weatherDetailCell.leftTitle.text = leftTitle
        weatherDetailCell.leftValue.text = leftValue
        weatherDetailCell.rightTitle.text = rightTitle
        weatherDetailCell.rightValue.text = rightValue
    }
    
     func setDataForecast24Cell(forecast24Cell: Forecast24TableViewCell, weatherModel: Result) {
        forecast24Cell.forecastData = weatherModel.hourly
    }
}
//MARK:SetupLayout
extension MainViewController {
    func setupLayout() {
        view.addSubview(topView)
        topView.translatesAutoresizingMaskIntoConstraints = false
        topView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        topView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        topView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        topView.heightAnchor.constraint(equalToConstant: 250).isActive = true
        
        topView.addSubview(cityLabel)
        cityLabel.topAnchor.constraint(equalTo: topView.topAnchor, constant: 47).isActive = true
        cityLabel.leftAnchor.constraint(equalTo: topView.leftAnchor, constant: 8).isActive = true
        cityLabel.rightAnchor.constraint(equalTo: topView.rightAnchor, constant: -8).isActive = true
        
        topView.addSubview(weatherDescLabel)
        weatherDescLabel.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: 2).isActive = true
        weatherDescLabel.leftAnchor.constraint(equalTo: topView.leftAnchor, constant: 8).isActive = true
        weatherDescLabel.rightAnchor.constraint(equalTo: topView.rightAnchor, constant: -8).isActive = true
        
        topView.addSubview(tempLabel)
        tempLabel.topAnchor.constraint(equalTo: weatherDescLabel.bottomAnchor, constant: 11).isActive = true
        tempLabel.leftAnchor.constraint(equalTo: topView.leftAnchor, constant: 8).isActive = true
        tempLabel.rightAnchor.constraint(equalTo: topView.rightAnchor, constant: -8).isActive = true
        
        topView.addSubview(minTempLabel)
        minTempLabel.rightAnchor.constraint(equalTo: topView.rightAnchor, constant: -16).isActive = true
        minTempLabel.bottomAnchor.constraint(equalTo: topView.bottomAnchor, constant: -8).isActive = true
        
        topView.addSubview(maxTempLabel)
        maxTempLabel.rightAnchor.constraint(equalTo: minTempLabel.leftAnchor, constant: 8).isActive = true
        maxTempLabel.bottomAnchor.constraint(equalTo: topView.bottomAnchor, constant: -8).isActive = true
        
        topView.addSubview(dayTodayLabel)
        dayTodayLabel.leftAnchor.constraint(equalTo: topView.leftAnchor, constant: 16).isActive = true
        dayTodayLabel.bottomAnchor.constraint(equalTo: topView.bottomAnchor, constant: -8).isActive = true
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.topAnchor.constraint(equalTo: topView.bottomAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    //MARK: ScrollView Animation
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollDiff = (scrollView.contentOffset.y - previousScrollOffset)
        let isScrollingDown = scrollDiff > 0
        let isScrollingUp = scrollDiff < 0
        if canAnimateHeader(scrollView) {
            var newHeight = topView.heightConstraint?.constant
            
            if isScrollingDown {
                newHeight = max(minHeaderHeight, (topView.heightConstraint?.constant ?? 0) - abs(scrollDiff))
                //print("scrollDown")
            } else if isScrollingUp {
                newHeight = min(maxHeaderHeight, (topView.heightConstraint?.constant ?? 0) + abs(scrollDiff))
                //print("scrollUP")
            }
            if newHeight != topView.frame.height {
                topView.heightConstraint?.constant = newHeight ?? 0
                setScrollPosition()
                previousScrollOffset = scrollView.contentOffset.y
            }
            
            let alphaValue = getAlpha(h: newHeight ?? 250)
            //print(alphaValue)
            tempLabel.alpha = alphaValue
            minTempLabel.alpha = alphaValue
            maxTempLabel.alpha = alphaValue
            dayTodayLabel.alpha = alphaValue
        }
    }
    
    func canAnimateHeader (_ scrollView: UIScrollView) -> Bool {
        let scrollViewMaxHeight = scrollView.frame.height + topView.frame.height - minHeaderHeight
        return scrollView.contentSize.height > scrollViewMaxHeight
    }
    
    func setScrollPosition() {
        self.tableView.contentOffset = CGPoint(x:0, y: 0)
    }
    
    func getAlpha(h: CGFloat) -> CGFloat {
        let s: CGFloat
        if h == 250 {
            return 1
        } else if h == 110 {
            return 0
        } else {
            s = (h - 110)/140
        return s
        }
    }
}

