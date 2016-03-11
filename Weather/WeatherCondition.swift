//
//  WeatherCondition.swift
//  Weather
//
//  Created by Timur Galimov on 08/03/16.
//  Copyright © 2016 Timur Galimov. All rights reserved.
//

import Foundation
import CoreData

struct WeatherCondition {
    let iconURL: String
    let weatherDescription: String
    
    init(iconURL: String, description: String) {
        self.iconURL = iconURL
        self.weatherDescription = description
    }
    
    init(managedObject: NSManagedObject) {
        self.iconURL = managedObject.valueForKey(ModelKeys.IconURL) as! String
        self.weatherDescription = managedObject.valueForKey(ModelKeys.Description) as! String
    }
}
