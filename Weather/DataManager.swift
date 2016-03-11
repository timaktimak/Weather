//
//  DataManager.swift
//  Weather
//
//  Created by Timur Galimov on 08/03/16.
//  Copyright © 2016 Timur Galimov. All rights reserved.
//

import Foundation

class DataManager {
    static let sharedInstance = DataManager()
    
    var currentWeatherSortedValues: [RegionCurrentData]?
    var currentWeatherData = [String: RegionCurrentData]() {
        didSet {
            currentWeatherSortedValues = currentWeatherData.values.sort { $0.0.region < $0.1.region }
        }
    }
    var forecastWeatherData = [String: RegionForecastData]()
    
    init() {
        loadData()
    }
    
    func loadData() {
        let (weatherData, forecastData) = CoreDataManager.sharedInstance.loadAllData()
        for data in weatherData {
            currentWeatherData[data.region] = data
        }
        for data in forecastData {
            forecastWeatherData[data.region] = data
        }
    }
    
    func cacheCurrentData() {
        CoreDataManager.sharedInstance.deleteAllCurrentData()
        for (_, data) in currentWeatherData {
            CoreDataManager.sharedInstance.saveRegionCurrentData(data)
        }
    }
    
    func cacheForecastData() {
        CoreDataManager.sharedInstance.deleteAllForecastData()
        for (_, data) in forecastWeatherData {
            CoreDataManager.sharedInstance.saveRegionForecastData(data)
        }
    }
}
