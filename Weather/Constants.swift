//
//  Constants.swift
//  Weather
//
//  Created by Timur Galimov on 08/03/16.
//  Copyright © 2016 Timur Galimov. All rights reserved.
//

import Foundation

struct Constants {
    static let BaseURL = "http://api.openweathermap.org"
    static let APIKey = "b42804474e440d3ebd1f62b544cc5dec"
    private static let MainURL = BaseURL + "/data/2.5"
    static let ForecastURL = MainURL + "/forecast"
    static let CurrentWeatherURL = MainURL + "/weather"
    static let ImageURL = "http://openweathermap.org/img/w"
    
    static let LocationDetectedIdentifier = "LocationDetected"
}
