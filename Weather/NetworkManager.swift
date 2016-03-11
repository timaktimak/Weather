//
//  NetworkManager.swift
//  Weather
//
//  Created by Timur Galimov on 08/03/16.
//  Copyright © 2016 Timur Galimov. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class NetworkManager {
    
    static let sharedInstance = NetworkManager()
    private struct Keys {
        static let List = "list"
        static let City = "city"
        static let Name = "name"
        static let Main = "main"
        static let Temp = "temp"
        static let DateTxt = "dt_txt"
        static let Weather = "weather"
        static let Icon = "icon"
        static let Description = "description"
    }
    
    private func getParams(regionName: String) -> [String: String] {
        return ["q": regionName, "APPID": Constants.APIKey, "units": "metric"]
    }
    
    func getForecastForRegion(regionName: String, success: (forecastData: RegionForecastData)->(), failure: ()->()) {
        let params = getParams(regionName)
        
        Alamofire.request(.GET, Constants.ForecastURL, parameters: params)
            .responseJSON { response in
                if response.result.error?.code == -999 { return } //cancel
                
                if response.response?.statusCode == 409 || response.response?.statusCode == 429 {
                    // means that the server was busy with another request of mine, rerequesting is probably not the best
                    // solution but is used here due to time constaints
                    self.getForecastForRegion(regionName, success: success, failure: failure)
                    return
                }
                switch response.result {
                case .Success:
                    if let value = response.result.value where response.response?.statusCode == 200 {
                        let data = JSON(value)
                        let objects = data[Keys.List].arrayValue
                        let region = data[Keys.City][Keys.Name].stringValue
                        
                        var forecast = [WeatherData]()
                        for object in objects {
                            let temp = object[Keys.Main][Keys.Temp].doubleValue
                            let dateString = object[Keys.DateTxt].stringValue
                            let date = NSDate.dateFromString(dateString)!
                            let (hour, _, _) = date.getTimeComponents()
                            let conditionsData = object[Keys.Weather].arrayValue
                            let conditions = conditionsData.map {
                                WeatherCondition(iconURL: $0[Keys.Icon].stringValue, description: $0[Keys.Description].stringValue)
                            }
                            switch hour {
                            case 9:
                                let weather = WeatherData(temp: temp, dayTime: .Morning, conditions: conditions)
                                forecast.append(weather)
                            case 12:
                                let weather = WeatherData(temp: temp, dayTime: .Day, conditions: conditions)
                                forecast.append(weather)
                            case 18:
                                let weather = WeatherData(temp: temp, dayTime: .Evening, conditions: conditions)
                                forecast.append(weather)
                            default:
                                break
                            }
                            
                            if forecast.count == 3 {
                                break
                            }
                        }
                        
                        let forecastData = RegionForecastData(region: region)
                        forecastData.dateOfFetch = NSDate()
                        forecastData.data = forecast
                        
                        success(forecastData: forecastData)
                    }
                case .Failure:
                    failure()
                }
        }
        
    }
    
    func getCurrentWeatherForRegion(regionName: String, success: (currentData: RegionCurrentData)->(), failure: (()->())? = nil, noInternetBlock: (()->())? = nil) -> Alamofire.Request {
        let params = getParams(regionName)
        
        return Alamofire.request(.GET, Constants.CurrentWeatherURL, parameters: params)
            .responseJSON { response in
                
                if response.result.error?.code == -999 { return } //cancel
                
                if response.result.error?.code == -1009 {
                    noInternetBlock?()
                    return
                }
                
                if response.response?.statusCode == 409 || response.response?.statusCode == 429 {
                    // means that the server was busy with another request of mine, rerequesting is probably not the best
                    // solution but is used here due to time constaints
                    self.getCurrentWeatherForRegion(regionName, success: success, failure: failure)
                    return
                }
                
                switch response.result {
                case .Success:
                    if let value = response.result.value where response.response?.statusCode == 200 {
                        let data = JSON(value)
                        let temp = data[Keys.Main][Keys.Temp].doubleValue
                        let region = data[Keys.Name].stringValue
                        
                        let conditionsData = data[Keys.Weather].arrayValue
                        let conditions = conditionsData.map {
                            WeatherCondition(iconURL: $0[Keys.Icon].stringValue, description: $0[Keys.Description].stringValue)
                        }
                        let weatherData = RegionCurrentData(region: region)
                        weatherData.dateOfFetch = NSDate()
                        weatherData.data = WeatherData(temp: temp, dayTime: .Now, conditions: conditions)
                        success(currentData: weatherData)
                    }
                case .Failure:
                    failure?()
                }
        }
        
    }
    
}
