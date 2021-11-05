//
//  ViewController.swift
//  MoyaApiPractice
//
//  Created by linssuning on 2021/11/3.
//

import UIKit
import Moya

class MainViewController: UIViewController {
    
    let provider = MoyaProvider<WeatherData>()
    var currentWeather: CurrentWeather?
    
    var userInput: String = "taipei"
    var location: String = "zh_tw"
    
    // MARK: Properties
    lazy var weatherImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    var locationButton: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(systemName: "location"), for: .normal)
        button.tintColor = .clear
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getData()
        view.backgroundColor = UIColor(red: 81/255, green: 181/255, blue: 227/255, alpha: 1)
        view.addSubview(weatherImageView)
        view.addSubview(locationButton)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        weatherImageView.frame = CGRect(x: view.frame.width / 8, y: view.frame.height / 20, width: view.frame.width / 1.25, height: view.frame.width / 1.25)
        
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
    
}

