//
//  ViewController.swift
//  MoyaApiPractice
//
//  Created by linssuning on 2021/11/3.
//

import UIKit
import Moya
import CoreLocation

class MainViewController: UIViewController, CLLocationManagerDelegate {
    
    let provider = MoyaProvider<WeatherData>()
    var currentWeather: CurrentWeather?
    let locationManager = CLLocationManager()
    
    var currentLocation: CLLocation?
    
    var userInput: String = "taipei"
    var location: String = "zh_tw"
    
    // MARK: Properties
    lazy var weatherImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    var locationButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "location"), for: .normal)
        button.imageView?.setDimensions(height: 40, width: 40)
        button.tintColor = .white
        return button
    }()
    
    var searchButton: UIButton = {
        let button = UIButton(type: .system)
        var config = UIButton.Configuration.plain()
        config.background.image = UIImage(systemName: "magnifyingglass")
        config.background.imageContentMode = .scaleToFill
        button.configuration = config
        button.tintColor = .white
        return button
    }()
    
    var infoView: UIView = {
       let view = UIView()
        view.backgroundColor = UIColor(displayP3Red: 1, green: 1, blue: 1, alpha: 0.3)
        view.layer.cornerRadius = 20
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        configUI()
    }
    
    func getData() {
        
        provider.request(.currentWeather(cityName: userInput, lang: location)) { result in
            switch result {
            case let .success(moyaResponse):
                do {
                    let currentWeatherResponse = try moyaResponse.map(CurrentWeather.self)
                    print(currentWeatherResponse)
                    self.currentWeather = currentWeatherResponse
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
        if locations.isEmpty, currentLocation == nil {
            currentLocation = locations.first
            locationManager.stopUpdatingLocation()
        }
    }
    
    func configUI() {
        
        view.backgroundColor = UIColor(red: 81/255, green: 181/255, blue: 227/255, alpha: 1)
        
        view.addSubview(locationButton)
        locationButton.anchor(top: view.safeAreaLayoutGuide.topAnchor,  left: view.safeAreaLayoutGuide.leftAnchor, paddingTop: 10 ,paddingLeft: 30 , width: 35, height: 35)
    }
}

