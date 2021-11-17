//
//  API.swift
//  MoyaApiPractice
//
//  Created by linssuning on 2021/11/3.
//

import Foundation
import Moya

enum WeatherData {
    
    static let apiKey = "2220801afa8cca84ce6313c47c826e1e"
    
    case currentWeather(cityName: String, lang: String)
    case forecast(cityName: String, lang: String)
}

extension WeatherData: TargetType {
    
    var baseURL: URL {
        return URL(string: "https://api.openweathermap.org/")!
    }
    
    var path: String {
        switch self {
        case .currentWeather:
            return "data/2.5/weather"
        case .forecast:
            return "data/2.5/forecast"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .currentWeather:
            return .get
        case .forecast:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .currentWeather(let cityName, let lang):
            return .requestParameters(parameters: ["q": cityName, "units":"metric", "appid": WeatherData.apiKey, "lang": lang], encoding: URLEncoding.default)
        case .forecast(let cityName, let lang):
            return .requestParameters(parameters: ["q": cityName, "units":"metric", "appid": WeatherData.apiKey, "lang": lang], encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return ["Content-type": "application/json"]
    }
    
    
}
