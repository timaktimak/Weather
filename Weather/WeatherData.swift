//
//  WeatherData.swift
//  Weather
//
//  Created by Timur Galimov on 08/03/16.
//  Copyright © 2016 Timur Galimov. All rights reserved.
//

import Foundation
import CoreData

struct WeatherData {
    let temp: Double
    let dayTime: DayTime
    let conditions: [WeatherCondition]
    
    init(temp: Double, dayTime: DayTime, conditions: [WeatherCondition]) {
        self.temp = temp
        self.dayTime = dayTime
        self.conditions = conditions
    }
    
    init?(managedObject: NSManagedObject?) {
        guard let managedObject = managedObject else { return nil }
        self.temp = managedObject.valueForKey(ModelKeys.Temp) as! Double
        self.dayTime = DayTime(rawValue: managedObject.valueForKey(ModelKeys.DayTime) as! String)!
        self.conditions = (managedObject.valueForKey(ModelKeys.Conditions) as! NSSet).map { WeatherCondition(managedObject: $0 as! NSManagedObject) }
    }
}
