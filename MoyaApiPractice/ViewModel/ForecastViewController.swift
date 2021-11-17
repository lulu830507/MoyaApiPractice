//
//  ForecastViewController.swift
//  MoyaApiPractice
//
//  Created by linssuning on 2021/11/3.
//

import UIKit
import Moya

class ForecastViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    let provider = MoyaProvider<WeatherData>()
    var forecast: ForecastWeather?
    
    //notification practice
    var userInput: String?
    var location: String = "zh_tw"
    
    private var forecastTableView: UITableView = {
        let tableView = UITableView()
        
        tableView.backgroundColor = UIColor(red: 81/255, green: 181/255, blue: 227/255, alpha: 1)
        //tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        
        tableView.register(ForecastTableViewCell.self, forCellReuseIdentifier: ForecastTableViewCell.identifier)
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        forecastTableView.delegate = self
        forecastTableView.dataSource = self
        
        self.view.addSubview(forecastTableView)
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateCityNotification(notifiy:)), name: MainViewController.cityUpdateNotification, object: nil)
        
        getData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        forecastTableView.frame = view.bounds
    }
    
    // notification practice
    @objc func updateCityNotification(notifiy: Notification) {
         
        if let userInfo = notifiy.userInfo,
           let city = userInfo["city"] as? String {
            
            provider.request(.forecast(cityName: city, lang: location)) { result in
                
                switch result {
                case let .success(moyaResponse):
                    do {
                        let forecastResponse = try moyaResponse.map(ForecastWeather.self)
                        //print(forecastResponse)
                        self.forecast = forecastResponse
                    } catch {
                        print(error)
                    }
                case let .failure(error):
                    print(error)
                }
                
                self.forecastTableView.reloadData()
            }
        }

    }
    
    
    func getData() {
        
        let city = UserDefaults.standard.string(forKey: "city") ?? ""
        
        provider.request(.forecast(cityName: city, lang: location)) { result in

            switch result {
            case let .success(moyaResponse):
                do {
                    let forecastResponse = try moyaResponse.map(ForecastWeather.self)
                    //print(forecastResponse)
                    self.forecast = forecastResponse
                } catch {
                    print(error)
                }
            case let .failure(error):
                print(error)
            }

            self.forecastTableView.reloadData()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecast?.list.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ForecastTableViewCell.identifier, for: indexPath) as? ForecastTableViewCell else {
            return UITableViewCell()
        }
        let row = forecast?.list[indexPath.row]
        let today = Date.init(timeIntervalSince1970: Double(row?.dt ?? 0))
        cell.dateLabel.text = todayString(today)

        let iconStr = row?.weather[0].icon ?? ""
        let urlStr = "http://openweathermap.org/img/wn/\(iconStr)@2x.png"
        if let url = URL(string: urlStr) {
            URLSession.shared.dataTask(with: url) { data, Response, Error in
                if let data = data ,
                   let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        cell.weatherImageView.image = image
                        //print(urlStr)
                    }
                }
            }.resume()
        }
        
        let temp = row?.main.temp
        cell.tempLabel.text = "🌡 \(String(format: "%.0f", temp as! CVarArg))℃"
        
        let suffix = row?.weather.first?.icon.suffix(1)
        if suffix == "n" {
            cell.backgroundColor = UIColor(red: 2/255, green: 2/255, blue: 2/255, alpha: 0.7)
            cell.tempLabel.textColor = .white
            cell.dateLabel.textColor = .white
        } else if suffix == "d" {
            cell.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.8)
            cell.tempLabel.textColor = .black
            cell.dateLabel.textColor = .black
        }
        
        return cell
    }
    
    func todayString(_ date: Date, dateFormatter: String = "MM/dd E HH:mm a") -> String {
        
        let formatter = DateFormatter()
        formatter.locale = Locale.init(identifier: "en")
        formatter.dateFormat = dateFormatter
        let date = formatter.string(from: date)
        return date
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
