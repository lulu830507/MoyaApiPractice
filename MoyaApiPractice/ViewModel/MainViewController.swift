//
//  ViewController.swift
//  MoyaApiPractice
//
//  Created by linssuning on 2021/11/3.
//

import UIKit
import Moya
import CoreLocation

class MainViewController: UIViewController, CLLocationManagerDelegate, UISearchBarDelegate {
    
    static let cityUpdateNotification = Notification.Name("cityUpdateNotification")
    
    let provider = MoyaProvider<WeatherData>()
    var currentWeather: CurrentWeather?
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    let gradientLayer = CAGradientLayer()
    
    var city: String = "Cupertino"
    var lang: String = "en"
    
    // MARK: Properties
    var searchBar: UISearchBar = {
       let searchBar = UISearchBar()
        
        return searchBar
    }()
    
    lazy var weatherImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    var locationButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "location"), for: .normal)
        button.imageView?.setDimensions(height: 35, width: 35)
        button.tintColor = .white
        return button
    }()
    
    var searchButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        button.imageView?.setDimensions(height: 35, width: 35)
        button.tintColor = .white
        return button
    }()
    
    var infoView: UIView = {
       let view = UIView()
        view.backgroundColor = UIColor(displayP3Red: 1, green: 1, blue: 1, alpha: 0.3)
        view.layer.cornerRadius = 20
        return view
    }()
    
    //info view data
    
    var descripLabel: WeatherLabel = {
        let label = WeatherLabel(text: "", font: 20)
        return label
    }()
    
    var dateLabel: WeatherLabel = {
        let label = WeatherLabel(text: "", font: 20)
        return label
    }()
    
    var timeLabel: WeatherLabel = {
        let label = WeatherLabel(text: "", font: 20)
        return label
    }()

    var cityLabel: WeatherLabel = {
        let label = WeatherLabel(text: "", font: 20)
        return label
    }()

    var tempLabel: WeatherLabel = {
        let label = WeatherLabel(text: "", font: 40)
        return label
    }()
    
    let personImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "person")
        image.tintColor = .white
        image.backgroundColor = .clear
        image.setDimensions(height: 30, width: 30)
        return image
    }()
    
    var temp2Label: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.tintColor = .white
        label.text = ""
        label.font = UIFont(name: "Menlo", size: 22)
        label.textColor = .white
        return label
    }()
    
    var verticalBar: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.tintColor = .white
        label.text = "|"
        label.font = UIFont(name: "Menlo", size: 25)
        label.textColor = .white
        return label
    }()
    
    let speedImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "wind")
        image.tintColor = .white
        image.backgroundColor = .clear
        image.setDimensions(height: 30, width: 30)
        return image
    }()
    
    var speedLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.tintColor = .white
        label.text = ""
        label.font = UIFont(name: "Menlo", size: 20)
        label.textColor = .white
        return label
    }()
    
    var verticalBar2: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.tintColor = .white
        label.text = "|"
        label.font = UIFont(name: "Menlo", size: 25)
        label.textColor = .white
        return label
    }()
    
    let humidImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "drop")
        image.tintColor = .white
        image.backgroundColor = .clear
        image.setDimensions(height: 30, width: 25)
        return image
    }()
    
    var humidLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.tintColor = .white
        label.text = ""
        label.font = UIFont(name: "Menlo", size: 20)
        label.textColor = .white
        return label
    }()
    
    var verticalBar3: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.tintColor = .white
        label.text = "|"
        label.font = UIFont(name: "Menlo", size: 25)
        label.textColor = .white
        return label
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpLocation()
        fetchData()
        searchBar.delegate = self
        searchBar.isHidden = true
        searchBar.placeholder = "Please enter a city name."
        
        searchButton.addTarget(self, action: #selector(didTapSearchButton), for: .touchUpInside)
        //漸層
        self.view.layer.insertSublayer(gradientLayer, at: 0)
        
        UserDefaults.standard.removeObject(forKey: "city")
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        configUI()
    }
    
    @objc func didTapSearchButton() {
        
        searchBar.isHidden = false
        searchBar.bringSubviewToFront(view)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
        
        if let userInput = searchBar.text {
            
            city = userInput
            
            UserDefaults.standard.set(city, forKey: "city")
            
            //notification practice
            NotificationCenter.default.post(name: MainViewController.cityUpdateNotification, object: nil, userInfo: ["city" : userInput])
            
            fetchData()
        }
        searchBar.isHidden = true
    }
    
    func fetchData() {
        
        provider.request(.currentWeather(cityName: city, lang: lang)) { result in
            switch result {
            case let .success(moyaResponse):
                do {
                    let currentWeatherResponse = try moyaResponse.map(CurrentWeather.self)
                   // print(currentWeatherResponse)
                    self.currentWeather = currentWeatherResponse
                    self.showCurrentWeatherInfo()
                    self.configUI()
                    self.getWeatherImage()
                } catch {
                    print(error)
                }
            case let .failure(error):
                print(error)
            }
        }
    }
    
    
    func getWeatherImage() {
        
        if let weatherIcon = self.currentWeather?.weather.first?.icon {
            let urlStr = "http://openweathermap.org/img/wn/\(weatherIcon)@2x.png"
            if let url = URL(string: urlStr) {
                URLSession.shared.dataTask(with: url) { data, Response, Error in
                    if let data = data ,
                       let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self.weatherImageView.image = image
                            print(urlStr)
                        }
                    }
                }.resume()
            }
        }
    }
    
    func setUpLocation() {
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        if !locations.isEmpty, currentLocation == nil {
            currentLocation = locations.first
            locationManager.stopUpdatingLocation()
        }
    }
    
    func configUI() {
        
        for view in view.subviews {
            view.removeFromSuperview()
        }
        
        view.addSubview(locationButton)
        locationButton.anchor(top: view.safeAreaLayoutGuide.topAnchor,  left: view.safeAreaLayoutGuide.leftAnchor, paddingTop: 10 ,paddingLeft: 30)
        
        view.addSubview(searchButton)
        searchButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, right: view.safeAreaLayoutGuide.rightAnchor, paddingTop: 10, paddingRight: -25)
        
        view.addSubview(searchBar)
        searchBar.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.safeAreaLayoutGuide.leftAnchor, right: view.safeAreaLayoutGuide.rightAnchor, paddingTop: 100, paddingLeft: 20, paddingRight: -20, width: 300, height: 40)
        
        
        view.addSubview(weatherImageView)
        view.insertSubview(weatherImageView, at: 1)
        weatherImageView.anchor(top: view.safeAreaLayoutGuide.topAnchor ,left: view.safeAreaLayoutGuide.leftAnchor, right: view.safeAreaLayoutGuide.rightAnchor, paddingTop: 10, width: 300, height: 300)
        
        view.addSubview(infoView)
        infoView.anchor(top: weatherImageView.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor,bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.safeAreaLayoutGuide.rightAnchor,paddingTop: -40, paddingLeft: 50, paddingBottom: -20, paddingRight: -50, width: 300, height: 400)
        
        view.addSubview(cityLabel)
        cityLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: locationButton.rightAnchor, paddingTop: 15, paddingLeft: 10)
        
    }
    
    func todayString(_ date: Date, dateFormatter: String = "yyyy / MM / dd") -> String {
        
        let formatter = DateFormatter()
        formatter.locale = Locale.init(identifier: "zh_CN")
        formatter.dateFormat = dateFormatter
        let date = formatter.string(from: date)
        return date
    }
    
    func hourToString(_ date: Date, dateFormatter: String = "HH : mm") -> String {
        
        let formatter = DateFormatter()
        formatter.locale = Locale.init(identifier: "zh_CN")
        formatter.dateFormat = dateFormatter
        let date = formatter.string(from: date)
        return date
    }
    
    
    func showCurrentWeatherInfo() {
        
        if let weatherDescription = self.currentWeather?.weather.first?.description,
           let cityName = self.currentWeather?.name,
           let date = self.currentWeather?.dt,
           let temp = self.currentWeather?.main.temp,
           let suffix = self.currentWeather?.weather.first?.icon.suffix(1),
           let humidity = self.currentWeather?.main.humidity,
           let speed = self.currentWeather?.wind.speed {
            DispatchQueue.main.async { [self] in
                
                let today = Date.init(timeIntervalSince1970: Double(date))
                self.dateLabel.text = todayString(today)
                infoView.addSubview(dateLabel)
                dateLabel.centerX(inView: infoView, topAnchor: infoView.topAnchor, paddingTop: 20)
                
                
                self.timeLabel.text = "Now"
                infoView.addSubview(timeLabel)
                timeLabel.centerX(inView: infoView, topAnchor: dateLabel.bottomAnchor, paddingTop: 20)
                
                self.tempLabel.text = (String(format: "%.0f", temp))+"℃"
                infoView.addSubview(tempLabel)
                tempLabel.centerX(inView: infoView, topAnchor: timeLabel.bottomAnchor, paddingTop: 30)
                
                self.descripLabel.text = weatherDescription
                infoView.addSubview(descripLabel)
                descripLabel.centerX(inView: infoView, topAnchor: tempLabel.bottomAnchor, paddingTop: 20)
                
                self.cityLabel.text = cityName
                
                if(suffix == "n") {
                    self.setDarkBlueGradient()
                } else {
                    self.setLightBlueGradient()
                }
                
                infoView.addSubview(personImage)
                personImage.anchor(top: descripLabel.bottomAnchor, left: infoView.leftAnchor, paddingTop: 38, paddingLeft: 55, width: 30, height: 30)
                infoView.addSubview(verticalBar)
                verticalBar.centerX(inView: infoView, topAnchor: descripLabel.bottomAnchor, paddingTop: 37)
                self.temp2Label.text = (String(format: "%.0f", temp))+"℃"
                infoView.addSubview(temp2Label)
                temp2Label.anchor(top: descripLabel.bottomAnchor, right: infoView.rightAnchor, paddingTop: 42, paddingRight: -40)
                
                infoView.addSubview(humidImage)
                humidImage.anchor(top: personImage.bottomAnchor, left: infoView.leftAnchor, paddingTop: 25, paddingLeft: 55, width: 25, height: 30)
                infoView.addSubview(verticalBar2)
                verticalBar2.centerX(inView: infoView, topAnchor: verticalBar.bottomAnchor, paddingTop: 25)
                self.humidLabel.text = String(humidity) + " %"
                infoView.addSubview(humidLabel)
                humidLabel.anchor(top: temp2Label.bottomAnchor, right: infoView.rightAnchor, paddingTop: 30, paddingRight: -40)
                
                infoView.addSubview(speedImage)
                speedImage.anchor(top: humidImage.bottomAnchor, left: infoView.leftAnchor, paddingTop: 25, paddingLeft: 55, width: 30, height: 30)
                infoView.addSubview(verticalBar3)
                verticalBar3.centerX(inView: infoView, topAnchor: verticalBar2.bottomAnchor, paddingTop: 25)
                self.speedLabel.text = String(speed) + "km/h"
                infoView.addSubview(speedLabel)
                speedLabel.anchor(top: humidLabel.bottomAnchor, right: infoView.rightAnchor, paddingTop: 30, paddingRight: -35)
            }
        }
    }
    
    func setLightBlueGradient() {
        
        let topColor = UIColor(red: 71/255, green: 191/255, blue: 223/255, alpha: 1).cgColor
        let bottomColor = UIColor(red: 74/255, green: 145/255, blue: 255.0/255, alpha: 1).cgColor
        gradientLayer.frame = view.bounds
        gradientLayer.startPoint = CGPoint(x: 1, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        gradientLayer.colors = [topColor, bottomColor]
    }

    
    func setDarkBlueGradient() {
        
        let topColor = UIColor(red: 19/255, green: 122/255, blue: 217/255, alpha: 1).cgColor
        let bottomColor = UIColor(red: 1/255, green: 9/255, blue: 21/255, alpha: 1).cgColor
        gradientLayer.frame = view.bounds
        gradientLayer.startPoint = CGPoint(x: 1, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        gradientLayer.colors = [topColor, bottomColor]
    }
    
    
}

