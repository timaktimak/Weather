//
//  InitialLoader.swift
//  Weather
//
//  Created by Timur Galimov on 08/03/16.
//  Copyright © 2016 Timur Galimov. All rights reserved.
//

import Foundation

class InitialLoader {
    
    private static let Key = "InitialDataLoaded"
    
    static func loadInitialData() {
        let defaults = NSUserDefaults.standardUserDefaults()
        if !defaults.boolForKey(Key) {
            DataManager.sharedInstance.currentWeatherData["London"] = RegionCurrentData(region: "London")
            DataManager.sharedInstance.currentWeatherData["Tokyo"] = RegionCurrentData(region: "Tokyo")
            DataManager.sharedInstance.currentWeatherData["New York"] = RegionCurrentData(region: "New York")
            DataManager.sharedInstance.cacheCurrentData()
            defaults.setBool(true, forKey: Key)
            defaults.synchronize()
        }
    }
}
